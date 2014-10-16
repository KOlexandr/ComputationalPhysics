import math
import numpy
import pylab
from labs.showresult import Solve

__author__ = 'Olexandr'


class FiniteDifference:
    @staticmethod
    def solve(func, func_diff, x_boundary, t_boundary, c, x_points_count, t_points_count):
        """
        utt(x,t) = c^2*uxx(x,t) on R = {(x,t): 0 <= x <= a, 0 <= t <= b},
        u(0,t) = 0, u(a,t) = 0 for 0 <= t <= b, u(x, 0) = f(x), ut(x, 0) = g(x) for 0 <= x <= a,
        :param func: f = u(x, 0)
        :param func_diff: g = ut(x, 0)
        :param x_boundary: right boundary for x
        :param t_boundary: right boundary for t
        :param c: constant coefficient wave equation
        :param x_points_count: number of points for x
        :param t_points_count: number of points for t
        :return: x - vector of x coordinates, t - vector of y coordinates, u - result (matrix of z coordinates)
        """
        x_step = x_boundary / (x_points_count - 1)
        t_step = t_boundary / (t_points_count - 1)
        r = c * t_step / x_step
        r2 = r ** 2
        r22 = r2 / 2
        s1 = 1 - r2
        s2 = 2 - 2 * r2
        u = pylab.zeros((x_points_count, t_points_count))

        for i in range(1, x_points_count - 1):
            u[i][0] = func(x_step * i)
            u[i][1] = s1 * func(x_step * i) + t_step * func_diff(x_step * i) + r22 * (
                func(x_step * (i + 1)) + func(x_step * (i - 1)))

        for j in range(2, t_points_count):
            for i in range(1, x_points_count - 1):
                u[i][j] = s2 * u[i][j - 1] + r2 * (u[i - 1][j - 1] + u[i + 1][j - 1]) - u[i][j - 2]

        u = numpy.transpose(u)
        x = [i * x_step for i in range(x_points_count)]
        t = [i * t_step for i in range(t_points_count)]
        return x, t, u

    @staticmethod
    def ex1(c, xc, tc):
        Solve.solve_exercise(lambda: FiniteDifference.solve(
            lambda z: math.sin(math.pi * z) + math.sin(2 * math.pi * z),
            lambda z: 0,
            1, 0.5, c, xc, tc
        ), plot_rojection_res=True, ain=15)

    @staticmethod
    def ex2(c, xc, tc):
        Solve.solve_exercise(lambda: FiniteDifference.solve(
            lambda z: z if 0 <= z <= 3 / 5 else 1.5 - 1.5 * z,
            lambda z: 0,
            1, 0.5, c, xc, tc
        ), plot_rojection_res=True, ain=150)

    @staticmethod
    def ex3(c, a, l, msc, xc, tc):
        Solve.solve_exercise(lambda: FiniteDifference.solve(
            lambda z: a * math.sin(math.pi / l * msc * z),
            lambda z: 0,
            1, 0.5, c, xc, tc
        ), plot_rojection_res=True, ain=15)

        def analytic_solve(func, x_boundary, t_boundary, x_points_count, t_points_count):
            x_step = x_boundary / (x_points_count - 1)
            t_step = t_boundary / (t_points_count - 1)
            x = [i * x_step for i in range(x_points_count)]
            t = [i * t_step for i in range(t_points_count)]
            u = pylab.zeros((t_points_count, x_points_count))
            for i in range(t_points_count):
                for j in range(x_points_count):
                    u[i][j] = func(x[j], t[i])
            return x, t, u

        Solve.solve_exercise(lambda: analytic_solve(
            lambda z, temp: a * math.sin(math.pi / l * z * msc) * math.cos(math.pi / l * msc * c * temp),
            1, 0.5, xc, tc
        ), plot_rojection_res=True, ain=15)


def main():
    c = 2
    a, l, msc = 1, 1, 4  # msc - початкова форма струни (кількість перегинів)
    # FiniteDifference.ex1(c, 100, 200)
    # FiniteDifference.ex2(c, 100, 200)
    FiniteDifference.ex3(c, a, l, msc, 100, 200)


main()