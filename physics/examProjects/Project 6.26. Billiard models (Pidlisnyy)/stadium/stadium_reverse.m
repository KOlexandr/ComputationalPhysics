function stadium_reverse
clc; close all; clear all;
global maxX maxY x_oblast y_oblast; 

N = 30;
dt = 1e-5;
minX = 0;
minY = 0;
maxX = round(sqrt(N))+1;
maxY = round(sqrt(N))+1;
Init_olbast;
max_step = 5000;

x(1) = maxX / 2;
y(1) = maxY / 2;
r(1) = 0.5/5;
m(1) = 1;
v(1,1) = 1000*rand-500;
v(2,1) = 1000*rand-500;
k = 1;


function [X, Y, Xx, Yy, x, y, v] = stadium(x, y, r, m, v, k)
    X = [x(1)];
    Y = [y(1)];
    for L=1:max_step
        tmp_x = x;
        tmp_y = y;
        for i=1:k
            flagi = 1;

            Len_oblast = length(x_oblast);
            for ii=1:Len_oblast
                if flagi && abs((x(i)-x_oblast(ii))^2 + (y(i)-y_oblast(ii))^2 - r(i)^2) < 0.01 && y_oblast(ii) ~= minY && y_oblast(ii) ~= maxY && y(i)-r(i)>minY && y(i)+r(i)<maxY
                    [v(1,i), v(2,i)] = check_bound_colision(x(i), y(i), v(1,i), v(2, i), r(i), m(i));
                    flagi = 0;
                end
            end

            if flagi && y(i)-r(i)<minY || y(i)+r(i)>maxY
                v(2,i) = -v(2,i);
                flagi = 0;
            end

            x(i) = x(i) + v(1,i)*dt;
            y(i) = y(i) + v(2,i)*dt;

            X = [X x(i)];  
            Y = [Y y(i)];

            dx = abs(tmp_x-x);
            dy = abs(tmp_y-y);
        end

        for i=1:k
            for j=1:180
                Xx(i,j) = r(i)*cos(2*pi*j/180)+x(i);
                Yy(i,j) = r(i)*sin(2*pi*j/180)+y(i);
            end
        end

%         plot(Xx,Yy,'.b');
%         axis([minX maxX minY maxY]);
% % 
%         pause(1e-6);

    end
end

[X, Y, Xx, Yy, x, y, v] = stadium(x, y, r, m, v, k);

hold on;
plot(x_oblast,y_oblast,'*k');

plot(Xx(1, :),Yy(1, :),'b');

plot(X, Y,'+b');
v1 = v;
v1(:,1) = -v1(:,1);

[X1, Y1, Xx, Yy, x1, y1, v1] = stadium(x, y, r, m, v1, k);

plot(X1, Y1, '.r');
R = maxX / 2;
axis([minX-R maxX+R minY maxY]);
end