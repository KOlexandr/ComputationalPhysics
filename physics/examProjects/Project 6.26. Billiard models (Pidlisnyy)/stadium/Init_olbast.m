function Init_olbast
global maxX maxY x_oblast y_oblast;
clc;
R = maxY/2;
dfi = 1e-2;
dx = 1e-2;
fi = -pi/2;
i = 0;
while fi < pi/2
    i = i+1;
    x_oblast(i) = R*cos(fi)+maxX;
    y_oblast(i) = R*sin(fi)+maxY/2;
    fi = fi + dfi;
end
x = maxX;
while x >= 0
    x = x - dx;
    i = i+1;
    x_oblast(i) = x;
    y_oblast(i) = maxY;
end
while fi < 3*pi/2
    i = i+1;
    x_oblast(i) = R*cos(fi);
    y_oblast(i) = R*sin(fi)+maxY/2;
    fi = fi + dfi;
end
x = 0;
while x <= maxX
    x = x + dx;
    i = i+1;
    x_oblast(i) = x;
    y_oblast(i) = 0;
end
% plot(x_oblast,y_oblast,'*');