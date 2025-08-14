import raylib;
import std.stdio : writeln;
import std.conv : to;
import std.math.rounding : round;
import std.math.algebraic : sqrt;
import std.math.exponential : pow;
import core.exception;

import algo.matrix;
import data.config;



int brushThickness = 5;
Color[][] canvas;

void pixel(Color[][] canvas, int a, int b) {
	try {
		canvas[a][b].r = 0;
		canvas[a][b].g = 0;
		canvas[a][b].b = 0;
		canvas[a][b].a = 255;
	} catch (ArrayIndexError) {
		return;
	}
}

void draw(Color[][] canvas, int a, int b, int radius) {
	for (int y = -radius; y <= radius; y++) {
		for (int x = -radius; x <= radius; x++) {
			if (x*x + y*y <= radius*radius) {
				int drawX = a + x;
				int drawY = b + y;
				pixel(canvas, drawX, drawY);
			}
		}
	}
}

void drawSquare(Color[][] canvas, int a, int b, int radius) {
	for (int y = -radius; y <= radius; y++) {
		for (int x = -radius; x <= radius; x++) {
			int drawX = a + x;
			int drawY = b + y;

			canvas[drawX][drawY].r = 0;
			canvas[drawX][drawY].g = 0;
			canvas[drawX][drawY].b = 0;
			canvas[drawX][drawY].a = 255;
		}
	}
}

void linear(Vector2 pos, Vector2 oldPos) {
	pos.x /= (GetScreenWidth()/width);
	pos.y /= (GetScreenHeight()/height);

	double dx = pos.x - oldPos.x;
	double dy = pos.y - oldPos.y;
	double distance = sqrt(dx*dx + dy*dy);

	for (int i = 0; i < to!int(distance); ++i) {
		double t = i / distance;
		double a = oldPos.x + dx * t;
		double b = oldPos.y + dy * t;

		int intA = to!int(a);
		int intB = to!int(b);
		draw(canvas, intA, intB, brushThickness);
	}
}

void naturalCubicSpline(Vector2 firstPos, Vector2 secondPos, Vector2 thirdPos) {
	double firstSlope = (secondPos.y - firstPos.y) / (secondPos.x - firstPos.x);
	double secondSlope = (thirdPos.y - secondPos.y) / (thirdPos.x - secondPos.x);

	auto polynomial = solveNsizedMatrix(
		[
			pow(firstPos.x,3), pow(firstPos.x,2), firstPos.x, 1,
			pow(secondPos.x, 3), pow(secondPos.y, 2), secondPos.x, 1,
			3*pow(firstPos.x, 2), 2*firstPos.x, 1, 0,
			3*pow(secondPos.x, 2), 2*secondPos.x, 1, 0
		],
		[
			firstPos.y,
			secondPos.y,
			firstSlope,
			secondSlope
		]
	);

	writeln(polynomial);

	double xDistance = secondPos.x - firstPos.x;

	double xPosOld = firstPos.x;

	for (int i = 0; i < to!int(xDistance); ++i) {
		double t = i / xDistance;

		double xPos = firstPos.x + t * xDistance;
		double yPos = polynomial[0][0]*pow(xPos, 3) + polynomial[1][0]*pow(xPos, 2) + polynomial[2][0]*xPos + polynomial[3][0];
		double yPosOld = polynomial[0][0]*pow(xPosOld, 3) + polynomial[1][0]*pow(xPosOld, 2) + polynomial[2][0]*xPosOld + polynomial[3][0];
		linear(Vector2(xPosOld, yPosOld), Vector2(xPos, yPos));

		xPosOld = xPos;
	}
}

void main()
{

    validateRaylibBinding();
    InitWindow(width, height, "Canvas");
    SetTargetFPS(60);
  
	for (int y = 0; y < width; y++) {
		Color[] row;
		for (int x = 0; x < height; x++) {
			Color c;
			c.r = 255;
			c.g = 255;
			c.b = 255;
			c.a = 0;
			row ~= c;
		}
		canvas ~= row;
	}


	naturalCubicSpline(Vector2(100, 400), Vector2(200, 500), Vector2(300, 400));
	naturalCubicSpline(Vector2(100, 400), Vector2(200, 300), Vector2(300, 400));

	naturalCubicSpline(Vector2(300, 800), Vector2(400, -2000), Vector2(500, 800));
	naturalCubicSpline(Vector2(400, -2000), Vector2(500, 800), Vector2(0, 0));

	Vector2 pos;
	Vector2 oldPos;

    while (!WindowShouldClose())
    {
        BeginDrawing();
        ClearBackground(Colors.RAYWHITE);

		if (IsMouseButtonDown(0)) {
			pos = GetMousePosition();

			if (IsMouseButtonPressed(0)) {
				oldPos = pos;
			}

			linear(pos, oldPos);

			oldPos = pos;
		}

		for (int x = 0; x < canvas.length; x++) {
			for (int y = 0; y < canvas[x].length; y++) {
				DrawRectangle(GetScreenWidth()/width*x, GetScreenHeight()/height*y, GetScreenWidth()/width, GetScreenHeight()/height, canvas[x][y]);
			}
		}

        EndDrawing();
    }
    CloseWindow();
}