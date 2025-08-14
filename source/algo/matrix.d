module algo.matrix;

// No need for a general solution because no larger/smaller matricies are used as of now
import std.stdio;
import mir.ndslice.slice: sliced;
import kaleidic.lubeck: mldivide;
import core.math : sqrt;
import std.conv : to;

void test()
{
    double[] a = [
         0, 0,  1,
         1,  1, 1,
        4,  2,  1];
    double[] b = [
         0,
         1,
         4];
    cubicSpline(a, b);
}
    

void cubicSpline(double[] a, double[] b) {
    // Given non-malformed input, the side length of matrix a will be the square root of its length
    int sideLength = to!int(sqrt(to!float(a.length)));

    // Perform AX=B operation
    auto x = a.sliced(sideLength,sideLength).mldivide(b.sliced(sideLength,1));
    writeln(x);
}