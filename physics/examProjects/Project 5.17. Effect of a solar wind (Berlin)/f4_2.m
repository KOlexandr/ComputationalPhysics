function z = f4_2 (x, y) % v'=-L*y / r^3;
global GM m;
z = -0.97/m*GM*y / r(x,y)^3;