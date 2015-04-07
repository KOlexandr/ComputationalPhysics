function a
clc;
K = 0;
Gamma = 0.4;
m = 10000;
Teta(1) = 0.2;
for i=1:m
    x = Teta(i) + Gamma-K/(2*pi).*sin(2*pi*Teta(i));
    Teta(i+1) = mod(x,1);
end
teta(1) = Teta(1);
W = 0;
for i=1:m
    teta(i+1) = teta(i) + Gamma-K/(2*pi).*sin(2*pi*teta(i));
    W = W + teta(i+1)-teta(i);
end
W = W/m