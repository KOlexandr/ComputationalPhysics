function sinai_g
clc; close all; clear all;
 
N = 30;
dt = 1e-4;
minX = 0;
minY = 0;
maxX = round(sqrt(N))+1;
maxY = round(sqrt(N))+1;

x(1) = maxX/2;
y(1) = maxY/2;
m(1) = 1e+4;
v(1,1) = 0;
v(2,1) = 0;
r(1) = maxX/3;


k = 2;

x(3) = 0.85*maxX;
y(3) = 0.85*maxY;
r(3) = 0.5/2;
m(3) = 1;
v(1,3) = 0;
v(2,3) = 0;

for j=1:180
    Xx(3,j) = r(3)*cos(2*pi*j/180)+x(3);
    Yy(3,j) = r(3)*sin(2*pi*j/180)+y(3);
end

maxN = 1000;
S = zeros(1, maxN);
flag = 0;

t0 = datetime('now')
for NN = 1 : 1e4
    if flag == 1 && n >= maxN
        nn = 1;
        while nn < n && nn < maxN
            S(nn) = S(nn) + 1;
            nn = nn + 1;
        end
        flag = 0;
    end
    
    r(2) = 0.5/4;
    x(2) = maxX * rand;
    if x(2) > x(1) - r(1) - r(2) && x(2) < x(1) + r(1) + r(2)
        x(2) = x(1) - r(1) - 2 * r(2);
    end
    y(2) = maxY * rand;
    if y(2) > y(1) - r(1) - r(2) && y(2) < y(1) + r(1) + r(2)
        y(2) = y(1) - r(1) - 2 * r(2);
    end
    m(2) = 1;
    v(1,2) = 4000*rand-2000;
    v(2,2) = 4000*rand-2000;
    n = 0;
    flag = 1;
    L = 0;
    while flag == 1 && n < maxN
        L=L+1;
        tmp_x = x;
        tmp_y = y;
        for i=1:k
            for j=i+1:k
                if x(i)-r(i)<minX || x(i)+r(i)>maxX
                    v(1,i) = -v(1,i);
                    n = n + 1;
                end

                if y(i)-r(i)<minY || y(i)+r(i)>maxY
                    v(2,i) = -v(2,i);
                    n = n + 1;
                end

                if x(j)-r(j)<minX || x(j)+r(j)>maxX
                    v(1,j) = -v(1,j);
                    n = n + 1;
                end

                if y(j)-r(j)<minY || y(j)+r(j)>maxY
                    v(2,j) = -v(2,j);
                    n = n + 1;
                end

                x(i) = x(i) + v(1,i)*dt;
                y(i) = y(i) + v(2,i)*dt;
                x(j) = x(j) + v(1,j)*dt;
                y(j) = y(j) + v(2,j)*dt;


                if (x(j)-x(3))^2+(y(j)-y(3))^2 <= r(3)^2
                    x(j) = -100;
                    y(j) = -100;
                    flag = 0;

                    nn = 1;
                    while nn < n && nn < maxN
                        S(nn) = S(nn) + 1;
                        nn = nn + 1;
                    end
                    
                end
                if (y(i)-y(j))^2 + (x(i)-x(j))^2 < (r(i)+r(j) + 0.001)^2
                    n = n + 1;
                    alfa = atan2(y(j)-y(i),x(j)-x(i));
                    co = cos(alfa);
                    si = sin(alfa);

                    pL1 = v(1,i)*co+v(2,i)*si;
                    pL2 = v(1,j)*co+v(2,j)*si;

                    pA1 = v(2,i)*co-v(1,i)*si;
                    pA2 = v(2,j)*co-v(1,j)*si;

                    P = m(i)*pL1 + m(j)*pL2;
                    V = pL1-pL2;
                    v2f = (P+m(i)*V)/(m(i)+m(j));
                    v1f = v2f - V;

                    pL1 = v1f;      
                    pL2 = v2f;

                    v(1,i) = pL1*co-pA1*si;
                    v(1,j) = pL2*co-pA2*si;
                    v(2,i) = pA1*co+pL1*si;
                    v(2,j) = pA2*co+pL2*si;
                end
            end
            dx = abs(tmp_x-x);
            dy = abs(tmp_y-y);
        end

        for i=1:k
            for j=1:180
                Xx(i,j) = r(i)*cos(2*pi*j/180)+x(i);
                Yy(i,j) = r(i)*sin(2*pi*j/180)+y(i);
            end
        end

    end
    NN
end
t0
t1 = datetime('now')


bar(S);
figure;
plot(S);