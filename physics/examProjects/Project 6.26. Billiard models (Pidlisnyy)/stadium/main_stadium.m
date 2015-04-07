function main_stadium
clc; close all; clear all;
global maxX maxY x_oblast y_oblast;
N = 30;
dt = 1e-5;
minX = 0;
minY = 0;
maxX = round(sqrt(N))+1;
maxY = round(sqrt(N))+1;
Init_olbast;
max_step = 2000;
k = 0;
for i=1:round(sqrt(N))
    for j=1:round(sqrt(N))
        k = k + 1;
        x(k) = j;
        y(k) = i;        
        r(k) = 0.5/5;
        m(k) = 1;
        v(1,k) = 4000*rand-2000;
        v(2,k) = 4000*rand-2000;
    end    
end
 
for L=1:max_step
    tmp_x = x;
    tmp_y = y;
    for i=1:k
        for j=i+1:k
            flagi = 1;
            flagj = 1;
            Len_oblast = length(x_oblast);
            for ii=1:Len_oblast
                if flagi && abs((x(i)-x_oblast(ii))^2 + (y(i)-y_oblast(ii))^2 - r(i)^2) < 0.01 && y_oblast(ii) ~= minY && y_oblast(ii) ~= maxY && y(i)-r(i)>minY && y(i)+r(i)<maxY
                    [v(1,i), v(2,i)] = check_bound_colision(x(i), y(i), v(1,i), v(2, i), r(i), m(i));
                    flagi = 0;
                end

                if flagj && abs((x(j)-x_oblast(ii))^2 + (y(j)-y_oblast(ii))^2 - r(j)^2) < 0.01 && y_oblast(ii) ~= minY && y_oblast(ii) ~= maxY && y(j)-r(j)>minY && y(j)+r(j)<maxY
                    [v(1,j), v(2,j)] = check_bound_colision(x(j), y(j), v(1,j), v(2, j), r(j), m(j));
                    flagj = 0;
                end
            end

            if flagi && y(i)-r(i)<minY || y(i)+r(i)>maxY
                v(2,i) = -v(2,i);
                flagi = 0;
            end

            if flagj && y(j)-r(j)<minY || y(j)+r(j)>maxY
                v(2,j) = -v(2,j);
                flagj = 0;
            end

            x(i) = x(i) + v(1,i)*dt;
            y(i) = y(i) + v(2,i)*dt;
            x(j) = x(j) + v(1,j)*dt;
            y(j) = y(j) + v(2,j)*dt;
                        
            if abs((y(i)-y(j))^2+(x(i)-x(j))^2-(r(i)+r(j))^2) < 0.05 
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
   
    plot(Xx,Yy,'.b',x_oblast,y_oblast,'*r');
      
    axis([min(x_oblast)-1 max(x_oblast)+1 min(y_oblast)-1 max(y_oblast)+1]);
    
    if L == 1
        savefig('fig1_1.fig');
    end
    if L == max_step / 2
        savefig('fig1_2.fig');
    end
    if L == max_step
        savefig('fig1_3.fig');
    end
    pause(1e-5);
end