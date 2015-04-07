function main
close all; clear all; clc;
global c;
c = [10, 0.1, 0.005, 0.02];
y0 = [2, 5, 4];
Y = [];
k = 0;
while c(2)<=0.16 
    k = k+1;
    [t, y] = ode45(@funcs,[0 1],y0);
    
    %¬иведен€ значень lny п≥сл€ перех≥дного пер≥оду у залежност≥ в≥д параметру с2
    %у точках, коли yдос€гаЇ максимум≥в
    figure(100000);
    xlabel('c(2)');
    ylabel('ln(Y)');
    hold on;
    for k = round(length(y(:,2))/2):length(y(:,2))-1
        if abs(y(k,2))>abs(y(k-1,2)) && abs(y(k,2))>abs(y(k+1,2))
            plot(c(2), log(y(k,2)), 'b.-');
        end
    end

    if mod(k,500) == 0
        figure;
        plot(t,y(:,2));
        xlabel('t');
        ylabel('Y');
        title('Y(t)');
    end
    
    c(2) = c(2) + 1e-4;
end

figure;
plot(y(:,1),y(:,2),'-r');
xlabel('X');
ylabel('Y');
title('Y(X)');

figure;
plot(y(:,1),y(:,3),'-m');
xlabel('X');
ylabel('Z');
title('Z(X)');

figure;
plot(y(:,2),y(:,3),'-b');
xlabel('Y');
ylabel('Z');
title('Z(Y)');

figure;
plot3(log(y(:,1)),log(y(:,2)),log(y(:,3)),'*-r');
xlabel('ln(X)');
ylabel('ln(Y)');
ylabel('ln(Z)');
title('3D Diagramma');
grid on;