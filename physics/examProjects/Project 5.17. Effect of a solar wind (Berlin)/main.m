% ������������� ����� ������-������� ��� ����'���� ���� ������
% �������, ��� ����� ���� ��� ������ ��������� � 2-� ������. 

% ��� ����, ��� ����������� �����, ���� �� ����� ���� ����'����� ���� �������
% ��������� ������ ������� �� ����������� ����, ����� �������� �� ��
% ������� � 2-� ���������������� ��������� �� ������� � 4-� ��������������� ������.

% ³������ �� ������ � ��� ��������, ����� � ��� �� ��������� ����� ���
% ������ ��������� ����(������ ����), ����� �� ��������� � ������ ����
% ������ �� ��(����� ����), ������� f(4_1),f(4_2). ����� ���������  - �� ����� ���� ����� �� Ox 
% ������� f(2),f(3).



function main 
clc; close all; clear all; 
global GM m; 
GM = 4*pi^2; 
m = 1;       

% ������ �������� �����

x(1) = pi;   % ��������� ��������� (���������� �)
vx(1) = 0;   % ��������� �������� (�������� �� ��� ��)
y(1) = 0;    % ��������� ��������� (���������� �)
vy(1) = pi;  % ��������� �������� (�������� �� ��� ��)
t(1) = 0;    % ������� ����� 
dt = 2e-3;  

i = 1;       
while t(i)<10 
   
	vx(i+1) = vx(i) + dt * f2(x(i),y(i));
    x(i+1) = x(i) + dt * f1(vx(i+1));
	
	vy(i+1) = vy(i) + dt * f4(x(i),y(i));
    y(i+1) = y(i) + dt * f3(vy(i+1));
    
    fprintf('x = %5.3f, y = %5.3f, Total_energy = %5.3f, ',x(i),y(i),0.5*m*(vx(i)^2+vy(i)^2)-GM*m/r(x(i),y(i)));
    fprintf('Total angular momentum = %5.3f\n',m*(x(i)*vy(i)-vx(i)*y(i)));
	t(i+1)= t(i)+dt;
    i = i+1;
end
x1 = x;
y1 = y;
vx1 = vx;
vy1 = vy;

i = 1;
while t(i)<10
    vx(i+1) = vx(i) + dt * f2(x(i),y(i));
    x(i+1) = x(i) + dt * f1(vx(i+1));
	
	vy(i+1) = vy(i) + dt * f4_1(x(i),y(i));
    y(i+1) = y(i) + dt * f3(vy(i+1));
	
    fprintf('x = %5.3f, y = %5.3f, Total_energy = %5.3f, ',x(i),y(i),0.5*m*(vx(i)^2+vy(i)^2)-GM*m/r(x(i),y(i)));
    fprintf('Total angular momentum = %5.3f\n',m*(x(i)*vy(i)-vx(i)*y(i)));
	i = i+1;
end
x2 = x;
y2 = y;
vx2 = vx;
vy2 = vy;

i = 1;
while t(i)<10
    vx(i+1) = vx(i) + dt * f2(x(i),y(i));
    x(i+1) = x(i) + dt * f1(vx(i+1));
	
	vy(i+1) = vy(i) + dt * f4_2(x(i),y(i));
    y(i+1) = y(i) + dt * f3(vy(i+1));
    
    fprintf('x = %5.3f, y = %5.3f, Total_energy = %5.3f, ',x(i),y(i),0.5*m*(vx(i)^2+vy(i)^2)-GM*m/r(x(i),y(i)));
    fprintf('Total angular momentum = %5.3f\n',m*(x(i)*vy(i)-vx(i)*y(i)));
    i = i+1;
end
x3 = x;
y3 = y;
vx3 = vx;
vy3 = vy;

% ³��������� ������� ��������� ����������

plot(x1,y1,x2,y2,x3,y3); 
figure;
plot(vx1,vy1,vx2,vy2,vx3,vy3); 