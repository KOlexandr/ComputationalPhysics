__author__ = 'Olexandr'

import pylab
import numpy as np
import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d.axes3d as p3
import matplotlib.animation as animation


class ShowResult:
    @staticmethod
    def print_results(x, t, u):
        print("t\\x\t\t" + "\t\t".join(["%.2f" % f for f in x]))
        for i in range(len(t)):
            print("%.2f\t" % t[i] + "\t".join(["%.6f" % f for f in u[i]]))
        print("\n")

    @staticmethod
    def plot_projection_results(x, t, u):
        x, t = pylab.meshgrid(x, t)

        fig = pylab.figure('Static Results (Surface with contour)')
        ax = p3.Axes3D(fig)
        ax.plot_surface(x, t, u, rstride=1, cstride=1, alpha=0.9)
        ax.contour(x, t, u, zdir='z', offset=u.min())
        ax.contour(x, t, u, zdir='x', offset=x.min())
        ax.contour(x, t, u, zdir='y', offset=t.max())
        ax.set_xlabel('x')
        ax.set_ylabel('t')
        ax.set_zlabel('u')

    @staticmethod
    def plot_simple_results(x, t, u):
        x, t = pylab.meshgrid(x, t)
        fig = pylab.figure('Static Result (WireFrame)')
        ax = p3.Axes3D(fig)
        ax.plot_wireframe(x, t, u)
        ax.set_xlabel('x')
        ax.set_ylabel('t')
        ax.set_zlabel('u')

    @staticmethod
    def animate_plot(x, u, time, interval):
        fig = plt.figure('Animate Result')
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

        animation.FuncAnimation(fig, animate, np.arange(1, time), init_func=init, interval=interval, blit=True)
        plt.grid()


class Solve:
    @staticmethod
    def solve_exercise(func, plot_simple_res=True, plot_projection_res=False, print_res=False, animate=True, ain=30):
        x, t, u = func()
        if animate:
            ShowResult.animate_plot(x, u, len(t), ain)
        if print_res:
            ShowResult.print_results(x, t, u)
        if plot_projection_res:
            ShowResult.plot_projection_results(x, t, u)
        if plot_simple_res:
            ShowResult.plot_simple_results(x, t, u)
        plt.show()