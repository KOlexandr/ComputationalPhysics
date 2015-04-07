function prj_5_19
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

dt = 0.001;
DISTANCE_OF_AUTOIONIZATION = 6;
n = 500000;

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

experementCounter = 1;
for k=0.6:0.02:1.3

    r1x(1) = 2;
    r1y(1) = 0;
    r2x(1) = -1;
    r2y(1) = 0;

    v1x(1) = k;
    v1y(1) = 0;
    v2x(1) = 0;
    v2y(1) = -1;

    time = 0;
    for i=1:n
        r12 = sqrt((r1x(i)-r2x(i))^2 + (r1y(i)-r2y(i))^2);
        % ----------------------------------------------------
        r1 = sqrt(r1x(i)^2+r1y(i)^2);

        v1x(i+1) = v1x(i) + dt*(-2* r1x(i)/r1^3 - (r1x(i)-r2x(i))/r12^3);
        r1x(i+1) = r1x(i) + dt*v1x(i+1);

        v1y(i+1) = v1y(i) + dt*(-2* r1y(i)/r1^3 - (r1y(i)-r2y(i))/r12^3);
        r1y(i+1) = r1y(i) + dt*v1y(i+1);
        % ----------------------------------------------------
        r2 = sqrt(r2x(i)^2+r2y(i)^2);

        v2x(i+1) = v2x(i) + dt*(-2* r2x(i)/r2^3 - (r2x(i)-r1x(i))/r12^3);
        r2x(i+1) = r2x(i) + dt*v2x(i+1);

        v2y(i+1) = v2y(i) + dt*(-2* r2y(i)/r2^3 - (r2y(i)-r1y(i))/r12^3);
        r2y(i+1) = r2y(i) + dt*v2y(i+1);

        time = time + dt;
        if ((sqrt(r1x(i+1)^2+r1y(i+1)^2) > DISTANCE_OF_AUTOIONIZATION) || (sqrt(r2x(i+1)^2+r2y(i+1)^2) > DISTANCE_OF_AUTOIONIZATION))
            autoIonizationTime(experementCounter) = time;
            experementCounter = experementCounter+1;
            break;
        end
    end
    % plot(r1x,r1y,'b');
    % hold on;
    % plot(r2x,r2y,'r');
    % grid on;
end



plot(0.6:0.02:1.3, autoIonizationTime);
grid on;

end
