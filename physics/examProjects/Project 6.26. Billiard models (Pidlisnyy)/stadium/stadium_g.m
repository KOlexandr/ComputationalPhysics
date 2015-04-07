function stadium_g
clc; close all; clear all;
global maxX maxY x_oblast y_oblast; 
 
N = 30;
dt = 1e-4;
minX = 0;
minY = 0;
maxX = round(sqrt(N))+1;
maxY = round(sqrt(N))+1;
R = maxX / 2;
k = 1;

Init_olbast;

x(2) = maxX + R / 2;
y(2) = maxY / 2;
r(2) = 0.5/2;
m(2) = 1;
v(1,2) = 0;
v(2,2) = 0;

for j=1:180
    Xx(1,j) = r(1)*cos(2*pi*j/180)+x(1);
    Yy(1,j) = r(1)*sin(2*pi*j/180)+y(1);
end

maxN = 100;
S = zeros(1, maxN);
flag = 0;

t0 = datetime('now')
for NN = 1 : 1e3
    if flag == 1 && n >= maxN
        nn = 1;
        while nn < n && nn < maxN
            S(nn) = S(nn) + 1;
            nn = nn + 1;
        end
        flag = 0;
    end
    
    r(1) = 0.5/4;
    x(1) = maxX * rand;
    y(1) = maxY * rand;  
    m(1) = 1;
    v(1,1) = 4000*rand-2000;
    v(2,1) = 4000*rand-2000;
    n = 0;
    flag = 1;
    L = 0;
    while flag == 1 && n < maxN
        L=L+1;
        tmp_x = x;
        tmp_y = y;
        for i=1:k
            flagi = 1;

            Len_oblast = length(x_oblast);
            for ii=1:Len_oblast
                if flagi && abs((x(i)-x_oblast(ii))^2 + (y(i)-y_oblast(ii))^2 - r(i)^2) < 0.05 && y_oblast(ii) ~= minY && y_oblast(ii) ~= maxY && y(i)-r(i)>minY && y(i)+r(i)<maxY
                    [v(1,i), v(2,i)] = check_bound_colision(x(i), y(i), v(1,i), v(2, i), r(i), m(i));
                    n = n + 1;
                    flagi = 0;
                end
            end

            if flagi && y(i)-r(i)<minY || y(i)+r(i)>maxY
                v(2,i) = -v(2,i);
                n = n + 1;
                flagi = 0;
            end


            x(i) = x(i) + v(1,i)*dt;
            y(i) = y(i) + v(2,i)*dt;


            if (x(i)-x(2))^2+(y(i)-y(2))^2 <= r(2)^2
                x(i) = -100;
                y(i) = -100;
                flag = 0;

                nn = 1;
                while nn < n && nn < maxN
                    S(nn) = S(nn) + 1;
                    nn = nn + 1;
                end

            end
           
        end

%         for i=1:2
%             for j=1:180
%                 Xx(i,j) = r(i)*cos(2*pi*j/180)+x(i);
%                 Yy(i,j) = r(i)*sin(2*pi*j/180)+y(i);
%             end
%         end
        
%         plot(Xx(1,:),Yy(1,:),'.b', Xx(2,:),Yy(2,:),'.r', x_oblast,y_oblast,'*k');
%         axis([minX-R maxX+R minY maxY]);
% 
%         pause(1e-6);

    end
    [NN, n]
end
t0
t1 = datetime('now')


bar(S);
figure;
plot(S);