function z = f2 (x, y) % u'=-L*x / r^3;
global GM m; 
z = -0.97/m*GM*x / r(x,y)^3; % ����� ������� ������� �������� �� 3% (��������� ������������ �� ����)