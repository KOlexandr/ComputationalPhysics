import math
import numpy
import pylab
import mpl_toolkits.mplot3d.axes3d as p3

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

    fig = pylab.figure()
    ax = p3.Axes3D(fig)
    ax.plot_wireframe(x, t, u)
    ax.set_xlabel('x')
    ax.set_ylabel('t')
    ax.set_zlabel('u')


def ex1(c):
    x, t, u = solve(
        lambda z: math.sin(math.pi*z) + math.sin(2*math.pi*z),
        lambda z: 0,
        1, 0.5, c, 11, 11
    )
    print_results(x, t, u)
    plot_static_results(x, t, u)


def ex2(c):
    x, t, u = solve(
        lambda z: z if 0 <= z <= 3 / 5 else 1.5 - 1.5 * z,
        lambda z: 0,
        1, 0.5, c, 11, 11
    )
    print_results(x, t, u)
    plot_static_results(x, t, u)


def ex3(c):
    a, l, m = 1, 2, 3

    def analytic_solve(func, x_boundary, t_boundary, x_points_count, t_points_count):
        x_step = x_boundary / (x_points_count - 1)
        t_step = t_boundary / (t_points_count - 1)
        x1 = [i * x_step for i in range(x_points_count)]
        t1 = [i * t_step for i in range(t_points_count)]
        u1 = pylab.zeros((x_points_count, t_points_count))
        for i in range(t_points_count):
            for j in range(x_points_count):
                u1[i][j] = func(x1[j], t1[i])
        return x1, t1, u1

    x, t, u = solve(
        lambda z: a * math.sin(math.pi / l * m * z),
        lambda z: 0,
        1, 0.5, c, 111, 111
    )
    print_results(x, t, u)
    plot_static_results(x, t, u)

    xa, ta, ua = analytic_solve(
        lambda z, temp: a * math.sin(math.pi / l * z * m) * math.cos(math.pi / l * m * c * temp),
        1, 0.5, 111, 111
    )
    print_results(xa, ta, ua)
    plot_static_results(xa, ta, ua)
    pylab.show()


def main():
    c = 2
    ex1(c)
    ex2(c)
    ex3(c)

    pylab.show()


main()