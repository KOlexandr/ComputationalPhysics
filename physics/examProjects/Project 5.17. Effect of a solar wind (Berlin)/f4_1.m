function z = f4_1 (x, y) % v'=-L*y / r^3;
global GM m;
z = -1.03/m*GM*y / r(x,y)^3;