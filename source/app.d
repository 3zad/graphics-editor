import raylib;
import std.stdio : writeln;
import std.conv : to;
import std.math.rounding : round;
import std.math.algebraic : sqrt;
import std.math.exponential : pow;
import core.exception;

import algo.matrix : test;

void naturalCubicSpline(Vector2 p0, Vector2 p1, Vector2 p2, Vector2 p3, int numPoints, double alpha=0.5) {

}

void catmullRomSpline(Vector2 p0, Vector2 p1, Vector2 p2, Vector2 p3, int numPoints, double alpha=0.5) {

}

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

void main()
{
	test();
	while (true) {
		
	}
    validateRaylibBinding();
    InitWindow(800, 800, "Canvas");
    SetTargetFPS(60);
 
	int width = 800;
	int height = 800;

	int brushThickness = 5;

	Color[][] canvas;
  
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