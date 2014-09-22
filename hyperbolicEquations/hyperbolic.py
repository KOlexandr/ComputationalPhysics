import math
import numpy
import pylab
import numpy as np
import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d.axes3d as p3
import matplotlib.animation as animation

__author__ = 'Olexandr'


def solve(func, func_diff, x_boundary, t_boundary, c, x_points_count, t_points_count):
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


def print_results(x, t, u):
    print("t\\x\t\t" + "\t\t".join(["%.2f" % f for f in x]))
    for i in range(len(t)):
        print("%.2f\t" % t[i] + "\t".join(["%.6f" % f for f in u[i]]))
    print("\n")


def plot_static_results(x, t, u):
    x, t = pylab.meshgrid(x, t)

    fig = pylab.figure('Data during all time')
    ax = p3.Axes3D(fig)
    ax.plot_surface(x, t, u, rstride=4, cstride=4, alpha=0.25)
    ax.contour(x, t, u, zdir='z', offset=u.min())
    ax.contour(x, t, u, zdir='x', offset=x.min())
    ax.contour(x, t, u, zdir='y', offset=t.max())
    ax.set_xlabel('x')
    ax.set_ylabel('t')
    ax.set_zlabel('u')


def animate_plot(x, u, time):
    fig = plt.figure('Data in each moment')
    ax = plt.axes(xlim=(min(x), max(x)), ylim=(u.min(), u.max()))
    ax.set_xlabel('x')
    ax.set_ylabel('u')
    line, = ax.plot([], [])

    def animate(i):
        line.set_data(x, u[i, :])
        return line,

    def init():
        line.set_data([], [])
        return line,

    animation.FuncAnimation(fig, animate, np.arange(1, time), init_func=init, interval=15, blit=True)
    plt.grid()


def solve_exercise(func, plot_static_res=True, print_res=False, animate=True):
    x, t, u = func()
    if animate:
        animate_plot(x, u, len(t))
    if print_res:
        print_results(x, t, u)
    if plot_static_res:
        plot_static_results(x, t, u)
    plt.show()


def ex1(c, xc, tc):
    solve_exercise(lambda: solve(
        lambda z: math.sin(math.pi * z) + math.sin(2 * math.pi * z),
        lambda z: 0,
        1, 0.5, c, xc, tc
    ))


def ex2(c, xc, tc):
    solve_exercise(lambda: solve(
        lambda z: z if 0 <= z <= 3 / 5 else 1.5 - 1.5 * z,
        lambda z: 0,
        1, 0.5, c, xc, tc
    ))


def ex3(c, a, l, msc, xc, tc):
    solve_exercise(lambda: solve(
        lambda z: a * math.sin(math.pi / l * msc * z),
        lambda z: 0,
        1, 0.5, c, xc, tc
    ))

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

    solve_exercise(lambda: analytic_solve(
        lambda z, temp: a * math.sin(math.pi / l * z * msc) * math.cos(math.pi / l * msc * c * temp),
        1, 0.5, xc, tc
    ))


def main():
    c = 2
    a, l, msc = 1, 1, 4  # msc - початкова форма струни (кількість перегинів)
    # ex1(c, 100, 200)
    # ex2(c, 100, 200)
    ex3(c, a, l, msc, 100, 200)


main()