function prj_4_17
% A -> X
% B + X -> Y + D
% 2X + Y -> 3X
% X -> C
% ---------------
% dX/dt = A - (B+1)X + X^2*Y
% dY/dt = BX - X^2*Y

A = 1;
B = 0.8;
X(1) = A;
Y(1) = B/A;
% if (B > A) then periodic, else steady state

h = 1e-2;
n = 2000;

for i=1:n
    X(i+1) = (A - (B + 1)*X(i) + X(i)^2 * Y(i))*h + X(i);
    Y(i+1) = (B*X(i) - X(i)^2 * Y(i))*h + Y(i);
end

plot(X,'b');
hold on;
plot(Y,'g');
grid on;

end