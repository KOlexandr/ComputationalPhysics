function prj_4_17
% dX/dt = A - (B+1)X + X^2*Y
% dY/dt = BX - X^2*Y

A = 0.6;
B = 1.8;
X(1) = A+0.001;
Y(1) = B/A;

% if (B > 2*A) then periodic, else steady state
% to show this, uncomment T2 group and comment T1
% also you can change A and B above

h = 1e-2;
n = 10000;

for i=1:n
    X(i+1) = (A - (B + 1)*X(i) + X(i)^2 * Y(i))*h + X(i);
    Y(i+1) = (B*X(i) - X(i)^2 * Y(i))*h + Y(i);
end

% T2
% plot(X,'b');
% hold on;
% plot(Y,'g');
% grid on;

% T1
 plot (X,Y);
 grid on;

end