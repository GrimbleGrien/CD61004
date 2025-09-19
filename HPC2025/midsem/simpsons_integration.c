// Program to compute the integration of a function using Simpson's formula


#include <stdio.h>

// Function to be integrated
double func(double x) {
    return x * x;  // example function f(x) = x^2
}

int main() {
    int n = 100000;   // number of subintervals (must be even)
    double a = 0.0, b = 1.0;  // interval limits
    double h = (b - a) / n;
    double sum = 0.0;
    double x;
    int i;

    // Initial sum includes function values at endpoints
    sum = func(a) + func(b);

    // Sum of 4 * f(x_odd)
    for (i = 1; i < n; i += 2) {
        x = a + i * h;
        sum += 4.0 * func(x);
    }

    // Sum of 2 * f(x_even)
    for (i = 2; i < n; i += 2) {
        x = a + i * h;
        sum += 2.0 * func(x);
    }

    // Calculate integral
    double integral = sum * h / 3.0;

    printf("Result of Simpson's integration: %lf\n", integral);

    return 0;
}

