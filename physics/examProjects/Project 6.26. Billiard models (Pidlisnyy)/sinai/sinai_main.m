function sinai_main
clc; close all; clear all;
 
N = 40;
dt = 1e-5;
minX = 0;
minY = 0;
maxX = round(sqrt(N))+1;
maxY = round(sqrt(N))+1;
max_step = 2000;
 
k = 1;
x(k) = maxX/2;
y(k) = maxY/2;
r(k) = x(k)/3;
m(k) = 1.0e+4;
v(1,k) = 0;
v(2,k) = 0;
k = 2;
for i=1:round(sqrt(N))
    for j=1:round(sqrt(N))
        x(k) = j;
        y(k) = i;        
        r(k) = 0.5/5;
        m(k) = 1;
        v(1,k) = 600*rand-300;
        v(2,k) = 600*rand-300;
        if (x(1)-x(k))^2+(y(1)-y(k))^2 > (r(1)+r(k))*2
            k = k + 1;
        end
    end    
end
k = k-2
% index = ceil(rand*(k-1))+1;
% r(index) = r(index)*2;
% v(1,index) = 0;
% v(2,index) = 0;
% m(index) = 1e+4;
count = 0;
Mass = [];
for L=1:max_step
    tmp_x = x;
    tmp_y = y;
    for i=1:k
        for j=i+1:k
            if x(i)-r(i)<minX || x(i)+r(i)>maxX
                v(1,i) = -v(1,i);
            end
            
            if y(i)-r(i)<minY || y(i)+r(i)>maxY
                v(2,i) = -v(2,i);
            end
            
            if x(j)-r(j)<minX || x(j)+r(j)>maxX
                v(1,j) = -v(1,j);
            end
 
            if y(j)-r(j)<minY || y(j)+r(j)>maxY
                v(2,j) = -v(2,j);
            end
                       
            x(i) = x(i) + v(1,i)*dt;
            y(i) = y(i) + v(2,i)*dt;
            x(j) = x(j) + v(1,j)*dt;
            y(j) = y(j) + v(2,j)*dt;
                
            
            if (y(i)-y(j))^2 + (x(i)-x(j))^2 < (r(i)+r(j) + 0.001)^2
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
   
    plot(Xx(2:end,:),Yy(2:end,:),'.b', Xx(1,:),Yy(1,:),'.k');
    axis([minX maxX minY maxY]);
  
    pause(1e-5);        
    end
