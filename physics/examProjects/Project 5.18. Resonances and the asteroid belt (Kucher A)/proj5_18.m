
function proj5_18

%T^2=4pi^2/GM*r^3;
%r1^3=(T1^2*GM1)/4pi^2;
%r2^3=(T2^2*GM2)/4pi^2;
%r21^3=(T2^2*GM2)/4pi^2-(T1^2*GM1)/4pi^2;
%T=1/3
T1=11.86;
T2=1/3*T1;
a1=5.202;
a2_cub=a1^3*(3/7)^2
a2=a2_cub.^(1/3);
GM=4*pi*pi;
GM1=0.001*GM;
GM2=((a2^3/T2^2))*GM;



dt = 0.01;
%n = 1/dt;
n = 5000;

% --------------
r1x = zeros(n,1);
r1y = zeros(n,1);
r2x = zeros(n,1);
r2y = zeros(n,1);

v1x = zeros(n,1);
v1y = zeros(n,1);
v2x = zeros(n,1);
v2y = zeros(n,1);


% --------------
r1x(1) = 5.24;
r1y(1) = 0;
r2x(1) = a2;
r2y(1) = 0;

v1x(1) = 0;
v1y(1) = sqrt(GM/5.24);
v2x(1) = 0;
v2y(1) = sqrt(GM/a2);
%r21_v=((T2^2*GM2)/GM).^(1/3)-((T1^2*GM1)/GM).^(1/3);
for i=1:n
    r21 = sqrt((r2x(i)- r1x(i))^2 + (r2y(i)- r1y(i))^2);
    r21x(i)= (r2x(i)-r1x(i));
    r21y(i)= (r2y(i)-r1y(i));
    r1 = sqrt(r1x(i)^2+r1y(i)^2);
    %r2 = sqrt(r2x(i)^2+r2y(i)^2);
    % ----------------------------------------------------
  
    v1x(i+1) = v1x(i) + dt* -GM*r1x(i)/r1^3 ;
    r1x(i+1) = r1x(i) + dt* v1x(i+1);
    
    v1y(i+1) = v1y(i) + dt* -GM*r1y(i)/r1^3;
    r1y(i+1) = r1y(i) + dt* v1y(i+1);
      
    % ----------------------------------------------------
   
    r2 = sqrt(r2x(i)^2+r2y(i)^2);
    v2x(i+1) = v2x(i) + dt* (-GM*r2x(i)/r2^3- GM1*r21x(i)/r21^3);
    r2x(i+1) = r2x(i) + dt*v2x(i+1);
      
    v2y(i+1) = v2y(i) + dt* (-GM*r2y(i)/r2^3- GM1*r21y(i)/r21^3);
    r2y(i+1) = r2y(i) + dt*v2y(i+1);
     
end


plot(r1x,r1y,'b');
hold on;
plot(r2x,r2y,'r');
grid on;

end

