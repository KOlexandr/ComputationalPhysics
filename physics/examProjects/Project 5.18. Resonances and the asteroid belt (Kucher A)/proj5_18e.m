function proj5_18e
clc
%T^2=4pi^2/GM*r^3;
%r1^3=(T1^2*GM1)/4pi^2;
%r2^3=(T2^2*GM2)/4pi^2;
%r21^3=(T2^2*GM2)/4pi^2-(T1^2*GM1)/4pi^2;
%T=1/3

period = [1/3,3/7,2/5,2/3];
T1=11.86;
m=1.99e+30;
T2=1/3*T1;
T2_kv=T2^2;
a1=5.202;
a2_cub=a1^3*(3/7)^2;
a2=a2_cub.^(1/3);
GM=4*pi*pi;
GM1=0.001*GM;
GM2=((a2_cub/T2^2)/4000)*GM;
%GM2=G*M2;
%r2=((GM2*T2^2)/GM).^1/3;



dt = 0.01;
t=5000;
n = t/dt;

r1x = zeros(n,1);
r1y = zeros(n,1);
r2x = zeros(n,1);
r2y = zeros(n,1);

v1x = zeros(n,1);
v1y = zeros(n,1);
v2x = zeros(n,1);
v2y = zeros(n,1);

t=zeros(n,1);
%r21_v=(T2^2*GM2/GM)-(T1^2*GM1/GM);
index=1;

hold on
% --------------
for j= 2:0.02:5
    r2x(1)=j;
    r2y(1) = 0; 
    v2x(1) = 0;
    v2y(1) = sqrt(GM/j);
 %   t(1)=0;
 % r = sqrt(r2x.^2 +  r2y.^2);
  % v = sqrt(v2x.^2 + v2y.^2);
for i=1:n
   %r = sqrt(r2x(i)^2 +  r2y(i)^2);
   %v = sqrt(v2x(i)^2 + v2y(i) ^2);
    r21x(i)= (r2x(i)-r1x(i));
    r21y(i)= (r2y(i)-r1y(i));
    r21(i)=sqrt(r2x(i)-r1x(i)).^2+(r2y(i)-r1y(i)).^2;
% 
%    
%     
%     v2x(i+1) = v2x(i) + dt * (- GM*GM *r2x(i)/T2^2*GM2);%- GM1/r21_v * r21(i));
%     r2x(i+1) = r2x(i) + dt * v2x(i+1);
%    
%     v2y(i+1) = v2y(i) + dt * (- GM*GM *r2y(i)/T2^2*GM2);% - GM1/r21_v * r21(i));
%     r2y(i+1) = r2y(i) + dt * v2y(i+1);
   r2 = sqrt(r2x(i)^2+r2y(i)^2);
    v2x(i+1) = v2x(i) + dt* (-GM*r2x(i)/r2^3);%- GM1*r21x(i)/r21^3);
    r2x( i+1) = r2x(i) + dt*v2x(i+1);
      
    v2y(i+1) = v2y(i) + dt* (-GM*r2y(i)/r2^3);%- GM1*r21y(i)/r21^3);
    r2y(i+1) = r2y(i) + dt*v2y(i+1);
%   r(i+1) = sqrt(r2x(i+1)^2 +  r2y(i+1)^2);
%   t(i+1)=t(i)+dt;

 end 
 r = sqrt(r2x(n)^2 +  r2y(n)^2);
 v2 = v2x(n)^2 + v2y(n) ^2;
%plot(t,r)

a(index) = (-2*GM/(v2/2 - GM/r));
index=index+1;
end

index
a_min=min(a)
a_max=max(a)

nc=floor((a_max-a_min)/0.1)+1
xc=a_min:0.1:a_max
count=zeros(nc,1);

for i=1:index-1
    for j=1:nc-1
        if(a(i)>xc(j) && (a(i)<=xc(j+1)))
            count(j)=count(j)+1;
        end
    end
end
bar( xc,count);
%grid on;
%plot(t,a,'b');


