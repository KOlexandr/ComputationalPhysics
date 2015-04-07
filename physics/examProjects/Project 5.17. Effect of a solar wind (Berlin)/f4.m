function z = f4 (x, y) %/v'=-L*y / r^3;
global GM m;
z = -GM/m*y / r(x,y)^3;