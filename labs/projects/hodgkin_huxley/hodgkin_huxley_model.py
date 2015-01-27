from math import exp
from labs.showresult import ShowResult

__author__ = 'Olexandr'


class HodgkinHuxley:
    def __init__(self):
        self.c = 1.0  # uF/cm^2
        self.gk = 36  # mmho/cm^2
        self.gna = 120  # mmho/cm^2
        self.gl = 0.3  # mmho/cm^2
        self.vk = 12  # mV
        self.vna = 12  # mV
        self.vl = 10.6  # mV

    @staticmethod
    def an(v):
        return (0.01 * (v + 10)) / (exp(1 + v / 10) - 1)

    @staticmethod
    def bn(v):
        return 0.125 * exp(v / 80)

    @staticmethod
    def am(v):
        return (0.01 * (v + 25)) / (exp(2.5 + v / 10) - 1)

    @staticmethod
    def bm(v):
        return 4 * exp(v / 18)

    @staticmethod
    def ah(v):
        return 0.07 * exp(v / 20)

    @staticmethod
    def bh(v):
        return 1 / (exp(3 + v / 10) + 1)

    @staticmethod
    def euler(func, predicate, x, y, dt, steps):
        """
        * solve first-order differential equation with Euler method
        * :param func - function
        * :param p - function for stop counts
        * :param x - initial (first) value of x, default use 0 (time)
        * :param y - initial (first) value of y
        * :param dt - step of time
        * :param allSteps - number of all steps
        """
        def euler_in(i, points):
            if i >= steps or not predicate(points[i][1]):
                return points
            else:
                return euler_in(i + 1, points + [(points[i][0] + dt, points[i][1] + dt * func(points[i][1]))])

        return euler_in(0, [(x, y)])

    def s(self):
        v = -70
        n, m, h = 0, 0, 0
        iext = lambda x: 0
        dt = 0.01
        v_list = []
        n_list = []
        m_list = []
        h_list = []
        t_list = []
        for i in range(100000):
            v += dt * ((-self.gk * (n ** 4) * (v - self.vk) - self.gna * (m ** 3) * h * (v - self.vna) - self.gl * (v - self.vl) + iext(i)) / self.c)
            # n += dt * (self.an(v)*(1-n) - self.bn(v)*n)
            # m += dt * (self.am(v)*(1-m) - self.bm(v)*m)
            # h += dt * (self.ah(v)*(1-h) - self.bh(v)*h)
            v_list.append(v)
            n_list.append(n)
            m_list.append(m)
            h_list.append(h)
            t_list.append(i)
        ShowResult.plot_2d(t_list, v_list)


def main():
    hhm = HodgkinHuxley()
    hhm.s()


main()