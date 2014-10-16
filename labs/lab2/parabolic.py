import math
import numpy
import pylab
from labs.showresult import Solve

__author__ = 'Olexandr'


class ExplicitScheme:
    @staticmethod
    def solve(func, c1, c2, a, b, c, n, m):
        """
        ut(x,t) = c^2*uxx(x,t) on R = {(x,t): 0 <= x <= a, 0 <= t <= b},
        u(x, 0) = f(x) for 0 <= x <= a, u(0,t) = c1, u(a,t) = c2 for 0 <= t <= b
        :param func: f = u(x, 0)
        :param c1: u(0, t)
        :param c2: u(a, t)
        :param a: right boundary for x
        :param b: right boundary for t
        :param c: constant coefficient heat equation
        :param n: number of points for x
        :param m: number of points for t
        :return: x - vector of x coordinates, t - vector of y coordinates, u - result (matrix of z coordinates)
        """
        h = a / (n - 1)
        k = b / (m - 1)
        r = c**2 * k / (h**2)
        s = 1 - 2 * r
        u = pylab.zeros((n, m))

        #boundary conditions
        u[0, :] = c1
        u[n-1, :] = c2

        #first line of values
        u[1:n-1, 0] = [func(i*h) for i in range(1, n-1)]

        for j in range(1, m):
            for i in range(1, n - 1):
                u[i][j] = s * u[i][j - 1] + r * (u[i - 1][j - 1] + u[i + 1][j - 1])

        u = numpy.transpose(u)
        x = [i * h for i in range(n)]
        t = [i * k for i in range(m)]
        return x, t, u

    @staticmethod
    def example_1(c, xc, tc):
        """
        example #1: r = 0.2 (example 10.3, table 10.3)
        :param c: coefficient
        :param xc: count of point on Ox axis
        :param tc: count of point on time axis
        """
        Solve.solve_exercise(lambda: ExplicitScheme.solve(
            lambda x: 4*x - 4*x**2, 0, 0,
            1, 0.2, c, xc, tc
        ), plot_rojection_res=True, print_res=True, ain=100)

    @staticmethod
    def example_2(c, xc, tc):
        """
        example #2: r = 0.83333 (example 10.3, table 10.4)
        :param c: coefficient
        :param xc: count of point on Ox axis
        :param tc: count of point on time axis
        """
        Solve.solve_exercise(lambda: ExplicitScheme.solve(
            lambda x: 4*x - 4*x**2, 0, 0,
            1, 0.33333, c, xc, tc
        ), plot_rojection_res=True, print_res=True, ain=100)


class ImplicitScheme:
    @staticmethod
    def solve(func, c1, c2, a, b, c, n, m):
        """
        ut(x,t) = c^2*uxx(x,t) on R = {(x,t): 0 <= x <= a, 0 <= t <= b},
        u(x, 0) = f(x) for 0 <= x <= a, u(0,t) = c1, u(a,t) = c2 for 0 <= t <= b
        :param func: f = u(x, 0)
        :param c1: u(0, t)
        :param c2: u(a, t)
        :param a: right boundary for x
        :param b: right boundary for t
        :param c: constant coefficient heat equation
        :param n: number of points for x
        :param m: number of points for t
        :return: x - vector of x coordinates, t - vector of y coordinates, u - result (matrix of z coordinates)
        """
        h = a / (n - 1)
        k = b / (m - 1)
        r = c**2 * k / (h**2)
        s = 1 - 2 * r
        u = pylab.zeros((n, m))

        #boundary conditions
        u[0, :] = c1
        u[n-1, :] = c2

        #first line of values
        u[1:n-1, 0] = [func(i*h) for i in range(1, n-1)]

        for j in range(1, m):
            for i in range(1, n - 1):
                u[i][j] = s * u[i][j - 1] + r * (u[i - 1][j - 1] + u[i + 1][j - 1])

        u = numpy.transpose(u)
        x = [i * h for i in range(n)]
        t = [i * k for i in range(m)]
        return x, t, u

    @staticmethod
    def example_1(c, xc, tc):
        """
        example #1: r = 0.2 (example 10.3, table 10.3)
        :param c: coefficient
        :param xc: count of point on Ox axis
        :param tc: count of point on time axis
        """
        Solve.solve_exercise(lambda: ExplicitScheme.solve(
            lambda x: 4*x - 4*x**2, 0, 0,
            1, 0.2, c, xc, tc
        ), plot_rojection_res=True, print_res=True, ain=100)

    @staticmethod
    def example_2(c, xc, tc):
        """
        example #2: r = 0.83333 (example 10.3, table 10.4)
        :param c: coefficient
        :param xc: count of point on Ox axis
        :param tc: count of point on time axis
        """
        Solve.solve_exercise(lambda: ExplicitScheme.solve(
            lambda x: 4*x - 4*x**2, 0, 0,
            1, 0.33333, c, xc, tc
        ), plot_rojection_res=True, print_res=True, ain=100)


class KrankNikolson:
    @staticmethod
    def solve(func, c1, c2, a, b, c, n, m):
        """
        ut(x,t) = c^2*uxx(x,t) on R = {(x,t): 0 <= x <= a, 0 <= t <= b},
        u(x, 0) = f(x) for 0 <= x <= a, u(0,t) = c1, u(a,t) = c2 for 0 <= t <= b
        :param func: f = u(x, 0)
        :param c1: u(0, t)
        :param c2: u(a, t)
        :param a: right boundary for x
        :param b: right boundary for t
        :param c: constant coefficient heat equation
        :param n: number of points for x
        :param m: number of points for t
        :return: x - vector of x coordinates, t - vector of y coordinates, u - result (matrix of z coordinates)
        """
        h = a / (n - 1)
        k = b / (m - 1)
        r = c**2 * k / (h**2)
        s1 = 2 + 2/r
        s2 = 2/r - 2
        u = pylab.zeros((n, m))

        #boundary conditions
        u[0, :] = c1
        u[n-1, :] = c2

        #first line of values
        u[1:n-1, 0] = [func(i*h) for i in range(1, n-1)]

        # Formation of the diagonal and do not lie on the diagonal
        # elements of A, the vector constant in
        # and the solution of a tridiagonal system AX = B
        vd = [s1 for _ in range(n)]
        vd[0] = vd[n-1] = 1

        va = [-1 for _ in range(n-1)]
        va[n-2] = 0

        vc = [-1 for _ in range(n-1)]
        vc[0] = 0

        vb = [0 for _ in range(n)]
        vb[0], vb[n-1] = c1, c2

        for j in range(1, m):
            for i in range(1, n - 1):
                vb[i] = u[i - 1][j - 1] + u[i + 1][j - 1] + s2 * u[i][j - 1]
            u[:, j] = numpy.transpose(KrankNikolson.trisys(va, vd, vc, vb))

        u = numpy.transpose(u)
        x = [i * h for i in range(n)]
        t = [i * k for i in range(m)]
        return x, t, u

    @staticmethod
    def trisys(a, d, c, b):
        """
        Tridiagonal equations solver
        :param a: the subdiagonal of the coeffective matrix
        :param d: the main diagonal of the coeffective matrix
        :param c: the superdiagonal of the coeffective matrix
        :param b: the constant vector of the linear system
        """
        n = len(b)
        for i in range(1, n):
            mult = a[i - 1] / d[i - 1]
            d[i] = d[i] - mult * c[i - 1]
            b[i] = b[i] - mult * b[i - 1]
        x = list(range(n))
        x[-1] = b[-1] / d[-1]
        for i in range(n-2, -1, -1):
            x[i] = (b[i] - c[i] * x[i + 1]) / d[i]
        return x

    @staticmethod
    def example(c, xc, tc):
        """
        example #1: (example 10.4, table 10.5)
        :param c: coefficient
        :param xc: count of point on Ox axis
        :param tc: count of point on time axis
        """
        Solve.solve_exercise(lambda: ExplicitScheme.solve(
            lambda x: math.sin(math.pi*x) + math.sin(3*math.pi*x), 0, 0,
            1, 0.1, c, xc, tc
        ), plot_rojection_res=True, print_res=True, ain=100)


def main():
    c = 1
    # ExplicitScheme.example_1(c, 6, 11)
    # ImplicitScheme.example_1(c, 6, 11)

    # ExplicitScheme.example_2(c, 6, 11)
    # ImplicitScheme.example_2(c, 6, 11)

    KrankNikolson.example(c, 10, 11)


main()