function prj6_23
bifurk = 2^5;
r = 0.7:0.0001:1;
x0 = 0.5;
Nr = length(r);
Nx = 120;
fp = zeros(Nr,bifurk);
for ri = 1:Nr
    x = zeros(Nx,1);
    x(1) = x0;
    for i = 2:Nx
        x(i) = 4*x(i-1)*r(ri)*(1-x(i-1));
    end
    for k = 1:bifurk     
        fp(ri,k)=x(end-(k-1));       
    end
end

%linetypes = ['b.';'g.';'r.';'c.';'m.';'y.';'k.'];
all = figure;
hold on
grid on;
%plot(r,fp(:,1),'k.','markersize',10);
%plot(r,fp(:,2),'b.','markersize',10);
%plot(r,fp(:,3),'r.','markersize',10);
for k=1:bifurk
    plot(r,fp(:,k),'k.','markersize',10);
    %plot(r,fp(:,k),linetypes(k),'markersize',10);
    %linetypes(k)
end
axis([r(1) r(end) 0 1])
xlabel('r');
ylabel('x^*');
title('Chaotic Behavior in the Logisitic Equation');

rStudy = [0.9196 0.899];
s = figure;
grid on;
hold on;

colors = 'bgrcmyk';
for k = 1:length(rStudy)
    figure(all);
    plot([rStudy(k), rStudy(k)], [0,1], colors(k));
    
%     figure(s);
%     x(1) = x0;
%     for i=1:Nx-1
%        x(i+1) = 4 * rStudy(k) * x(i) * (1 - x(i));
%     end
%     plot(1:Nx,x, colors(k));
end

figure(s);
x(1) = x0;
for i = 2:Nx
    x(i) = 4*x(i-1)*0.9175*(1-x(i-1));
end
plot(x);
