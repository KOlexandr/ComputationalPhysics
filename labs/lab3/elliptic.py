import math
import pylab
from labs.showresult import Solve

__author__ = 'Olexandr'


class Dirichlel:
    @staticmethod
    def solve(f1, f2, f3, f4, a, b, h, tol, max_steps):
        """
        uxx(x,yt) + uyy(x,y) = 0 on R = {(x,y): 0 <= x <= a, 0 <= y <= b},
        u(x,0) = f1(x), u(x,b) = f2(x) for 0 <= x <= a, u(0,y) = f3(y), u(a,y) = f4(y) for 0 <= y <= b,
        :param f1: u(x,0)
        :param f2: u(x,b)
        :param f3: u(0,y)
        :param f4: u(a,y)
        :param a: right boundary for x
        :param b: right boundary for y
        :param h: step
        :param tol: maximum delta
        :param max_steps: max count of steps
        :return: x - vector of x coordinates, y - vector of y coordinates, u - result (matrix of z coordinates)
        """

        # initialize parameters in u
        n = int(a / h) + 1
        m = int(b / h) + 1
        ave = (a * (f1(0) + f2(0)) + b * (f3(0) + f4(0))) / (2 * a + 2 * b)

        u = ave * pylab.ones((n, m))

        # boundary conditions
        u[0, :] = [f3(i * h) for i in range(0, m)]
        u[n - 1, :] = [f4(i * h) for i in range(0, m)]
        u[:, 0] = [f1(i * h) for i in range(0, n)]
        u[:, m - 1] = [f2(i * h) for i in range(0, n)]

        u[0, 0] = (u[0, 1] + u[1, 0]) / 2
        u[0, m - 1] = (u[0, m - 2] + u[1, m - 1]) / 2
        u[n - 1, 0] = (u[n - 2, 0] + u[n - 1, 1]) / 2
        u[n - 1, m - 1] = (u[n - 2, m - 1] + u[n - 1, m - 2]) / 2

        # The parameter of consistent method of relax
        w = 4 / (2 + math.sqrt(4 - (math.cos(math.pi / (n - 1)) + math.cos(math.pi / (m - 1))) ** 2))

        # Improved approximation operator purification throughout the lattice
        error = 1
        count = 0

        while error > tol and count <= max_steps:
            error = 0

            for j in range(1, m - 1):
                for i in range(1, n - 1):
                    relax = w * (u[i][j + 1] + u[i][j - 1] + u[i + 1][j] + u[i - 1, j] - 4 * u[i][j]) / 4
                    u[i, j] += relax
                    if error <= math.fabs(relax):
                        error = math.fabs(relax)
            count += 1

        x = [i * h for i in range(n)]
        y = [i * h for i in range(m)]
        u = pylab.flipud(pylab.transpose(u))
        return x, y, u

    @staticmethod
    def solve_diff(f1, f2, f3, f4, a, b, h, tol, max_steps):
        """
        uxx(x,yt) + uyy(x,y) = 0 on R = {(x,y): 0 <= x <= a, 0 <= y <= b},
        uy(x,0) = f1(x), u(x,b) = f2(x) for 0 <= x <= a, u(0,y) = f3(y), u(a,y) = f4(y) for 0 <= y <= b,
        :param f1: u(x,0)
        :param f2: u(x,b)
        :param f3: u(0,y)
        :param f4: u(a,y)
        :param a: right boundary for x
        :param b: right boundary for y
        :param h: step
        :param tol: maximum delta
        :param max_steps: max count of steps
        :return: x - vector of x coordinates, y - vector of y coordinates, u - result (matrix of z coordinates)
        """

        # initialize parameters in u
        n = int(a / h) + 1
        m = int(b / h) + 1
        ave = (a * f2(0) + b * (f3(0) + f4(0))) / (2 * a + 2 * b)

        u = ave * pylab.ones((n, m))

        # boundary conditions
        u[0, :] = [f3(i * h) for i in range(0, m)]
        u[n - 1, :] = [f4(i * h) for i in range(0, m)]
        u[:, m - 1] = [f2(i * h) for i in range(0, n)]

        u[0, m - 1] = (u[0, m - 2] + u[1, m - 1]) / 2
        u[n - 1, m - 1] = (u[n - 2, m - 1] + u[n - 1, m - 2]) / 2

        # The parameter of consistent method of relax
        w = 4 / (2 + math.sqrt(4 - (math.cos(math.pi / (n - 1)) + math.cos(math.pi / (m - 1))) ** 2))

        # Improved approximation operator purification throughout the lattice
        error = 1
        count = 0

        while error > tol and count <= max_steps:
            error = 0

            for j in range(1, m - 1):
                for i in range(1, n - 1):
                    relax = w * (u[i][j + 1] + u[i][j - 1] + u[i + 1][j] + u[i - 1, j] - 4 * u[i][j]) / 4
                    u[i, j] += relax
                    if error <= math.fabs(relax):
                        error = math.fabs(relax)
                    u[i, 0] = f1(i * h, u, i, 0)
            count += 1

        x = [i * h for i in range(n)]
        y = [i * h for i in range(m)]
        u = pylab.flipud(pylab.transpose(u))
        return x, y, u

    @staticmethod
    def ex1(h, tol, max_steps):
        """
        example #1: (example 10.5, table 10.6)
        :param h: step
        :param tol: maximum delta
        :param max_steps: max count of steps
        """
        Solve.solve_exercise(lambda: Dirichlel.solve(
            lambda x: 20, lambda x: 180,
            lambda x: 80, lambda x: 0,
            4, 4, h, tol, max_steps
        ), plot_projection_res=True, ain=15, print_res=True)

    @staticmethod
    def ex2(h, tol, max_steps):
        """
        example #2: (example 10.6, table 10.7)
        :param h: step
        :param tol: maximum delta
        :param max_steps: max count of steps
        """
        Solve.solve_exercise(lambda: Dirichlel.solve_diff(
            lambda x, u, i, j: u[i, j + 1], lambda x: 180,
            lambda x: 80, lambda x: 0,
            4, 4, h, tol, max_steps
        ), plot_projection_res=True, ain=15, print_res=True)


def main():
    h, tol, max_step = 0.5, 0.002, 1000
    # Dirichlel.ex1(h, tol, max_step)
    Dirichlel.ex2(h, tol, max_step)


main()