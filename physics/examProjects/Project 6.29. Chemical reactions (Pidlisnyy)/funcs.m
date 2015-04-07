function y = funcs(t, y)
global c;
y = [c(1)+c(2)*y(3)-y(1)-y(1)*y(2)^2;
    (y(1)+y(1)*y(2)^2-y(2) + 0*t)/c(3);
    (y(2)-y(3))/c(4)];