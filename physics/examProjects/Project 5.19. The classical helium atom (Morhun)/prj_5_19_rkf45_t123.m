function prj_5_19_rkf45
% The classical helium atom 2D
% a1 = -2*r1/r1^3 + (r1 - r2)/r12^3
% a2 = -2*r2/r2^3 + (r2 - r1)/r12^3
% where 
% r1,r2 - distances from electrons to nuclear
% r12   - distance between electrons
% --------------------------------------
% a1x = -2* r1x/r1^3 - (r1x-r2x)/r12^3
% a1y = -2* r1y/r1^3 - (r1y-r2y)/r12^3
% a2x = -2* r2x/r2^3 - (r2x-r1x)/r12^3
% a2y = -2* r2y/r2^3 - (r2y-r1y)/r12^3
% nuclear in (0,0)


% -----------------------------------------------------------------
a2 = 1/4; b2 = 1/4; a3 = 3/8; b3 = 3/32; c3 = 9/32; a4 = 12/13;
b4 = 1932/2197; c4 = -7200/2197; d4 = 7296/2197; a5 = 1;
b5 = 439/216; c5 = -8; d5 = 3680/513; e5 = -845/4104; a6 = 1/2;
b6 = -8/27; c6 = 2; d6 = -3544/2565; e6 = 1859/4104; f6 = -11/40;
r1 = 1/360; r3 = -128/4275; r4 = -2197/75240; r5 = 1/50;
r6 = 2/55; n1 = 25/216; n3 = 1408/2565; n4 = 2197/4104; n5 = -1/5;
% -----------------------------------------------------------------

big = 1e15;
h = 0.001;
hmin = h/64;
hmax = 64*h;
tol = 1e-5;

% a
% r1x = 2;
% r1y = 0;
% r2x = -1;
% r2y = 0;
% v1x = 0;
% v1y = 0.95;
% v2x = 0;
% v2y = -1;

% b
% r1x = 1.4;
% r1y = 0;
% r2x = -1;
% r2y = 0;
% v1x = 0;
% v1y = 0.86;
% v2x = 0;
% v2y = -1;

% c
% r1x = 3;
% r1y = 0;
% r2x = 1;
% r2y = 0;
% v1x = 0;
% v1y = 0.4;
% v2x = 0;
% v2y = -1;

r1x = 2.5;
r1y = 0;
r2x = 1;
r2y = 0;
v1x = 0;
v1y = 0.4;
v2x = 0;
v2y = -1;


Y = [v1x r1x v1y r1y v2x r2x v2y r2y];

n = 500;
i = 1;
while ( i < n )
      ti = i;
      yi = Y(i,:)';
      
      y1 = yi;
      k1 = h*f(ti,y1);
      y2 = yi+b2*k1;                         if big<abs(y2) break, end
      k2 = h*f(ti+a2*h,y2);
      y3 = yi+b3*k1+c3*k2;                   if big<abs(y3) break, end
      k3 = h*f(ti+a3*h,y3);
      y4 = yi+b4*k1+c4*k2+d4*k3;             if big<abs(y4) break, end
      k4 = h*f(ti+a4*h,y4);
      y5 = yi+b5*k1+c5*k2+d5*k3+e5*k4;       if big<abs(y5) break, end
      k5 = h*f(ti+a5*h,y5);
      y6 = yi+b6*k1+c6*k2+d6*k3+e6*k4+f6*k5; if big<abs(y6) break, end
      k6 = h*f(ti+a6*h,y6);
      err = abs(r1*k1+r3*k3+r4*k4+r5*k5+r6*k6);
      ynew = yi+n1*k1+n3*k3+n4*k4+n5*k5;
      if ( (max(err) < tol) || (h <= 2*hmin) )
        Y(i+1,:) = ynew';
        i = i+1;
      end
      if (err == 0)
        s = 0;
      else
        s = 0.84*(tol*min(h)/max(err))^(0.25); % min/max
      end
      if ((s<0.75)&&(h>2*hmin)), h = h/2; end
      if ((s>1.50)&&(2*h<hmax)), h = 2*h; end
      %if ((big<abs(Y(i)))||(max1==i)), break, end
end
%plots
plot(Y(:,2),Y(:,4),'b');
hold on;
plot(Y(:,6),Y(:,8),'r');
grid on;

end

function dy = f(t, y)
%       1   2   3   4   5   6   7   8
% Y = [v1x r1x v1y r1y v2x r2x v2y r2y];
r12 = sqrt((y(2)-y(6))^2 + (y(4)-y(8))^2);
r1 = sqrt(y(2)^2+y(4)^2);
r2 = sqrt(y(6)^2+y(8)^2);
dy = [
     -2* y(2)/r1^3 - (y(2)-y(6))/r12^3;
     y(1);
     -2* y(4)/r1^3 - (y(4)-y(8))/r12^3;
     y(3);
     -2* y(6)/r2^3 - (y(6)-y(2))/r12^3;
     y(5);
     -2* y(8)/r2^3 - (y(8)-y(4))/r12^3;
     y(7);
     ];
end