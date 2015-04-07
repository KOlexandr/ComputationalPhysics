function stadium_d
clc; close all; clear all;
global maxX maxY x_oblast y_oblast; 

N = 30;
dt = 1e-4;
minX = 0;
minY = 0;
maxX = round(sqrt(N))+1;
maxY = round(sqrt(N))+1;
R = maxX / 2;

Init_olbast;

x(2) = maxX + R / 2;
y(2) = maxY / 2;
r(2) = 0.5/2;
m(2) = 1;
v(1,2) = 0;
v(2,2) = 0;

k = 1;


maxT = 0;
maxP = 0;

for j=1:180
    Xx(2,j) = r(2)*cos(2*pi*j/180)+x(2);
    Yy(2,j) = r(2)*sin(2*pi*j/180)+y(2);
end

NN = 500;
S = [];
flag = 0;

PP = 0.4000;
a = PP - PP / 4;
b = PP + PP / 4;

% a = 0;
% b = 1;

% t0 = datetime('now')
% for NN = 1 : 100 %5e3
px = a:((b-a)/NN):b;

for vx = a:((b-a)/NN):b    
    r(1) = 0.5/4;
    x(1) = minX - R/2;
    y(1) = maxY / 2;  
    m(1) = 1;
    v(1,1) = vx;
    v(2,1) = sqrt(1-vx^2); 
    
    v(1,1) = v(1,1) * 1000;
    v(2,1) = v(2,1) * 1000;
    
    flag = 1;
    steps = 0;
    while flag == 1
        steps = steps + 1;
        tmp_x = x;
        tmp_y = y;
        for i=1:k
            flagi = 1;

            Len_oblast = length(x_oblast);
            for ii=1:Len_oblast
                if flagi && abs((x(i)-x_oblast(ii))^2 + (y(i)-y_oblast(ii))^2 - r(i)^2) < 0.05 && y_oblast(ii) ~= minY && y_oblast(ii) ~= maxY && y(i)-r(i)>minY && y(i)+r(i)<maxY
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

            if (x(i)-x(2))^2+(y(i)-y(2))^2 <= r(2)^2
                x(i) = -100;
                y(i) = -100;
                flag = 0;
                time = dt * steps;
                S = [S time];
                if time > maxT
                    maxT = time;
                    maxP = vx;
                end

            end
                
            
           
        end

%         for i=1:k
%             for j=1:180
%                 Xx(i,j) = r(i)*cos(2*pi*j/180)+x(i);
%                 Yy(i,j) = r(i)*sin(2*pi*j/180)+y(i);
%             end
%         end
% 
%         plot(Xx(2:end,:),Yy(2:end,:),'.b', Xx(1,:),Yy(1,:),'.k');
%         axis([minX maxX minY maxY]);
% 
%         pause(1e-5);        
%         
    end
    vx
%     NN
end
% t0
% t1 = datetime('now')

plot(px, S);
maxP