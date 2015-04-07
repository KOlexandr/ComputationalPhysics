function [vx1, vy1] = check_bound_colision(x, y, vx, vy, r, m)
    global maxX maxY;
    R = maxY/2;
    Y = R;
    
    alfa = atan2(vy, vx);
    co = cos(alfa);
    si = sin(alfa);
    
    xc = x + r * co;
    yc = y + r * si;
    
    if xc < 0
        X = 0;
    else
        X = maxX;
    end

    c = [xc, yc];
    v = [vx, vy];
    n = [xc - X, yc - Y];
    
    v1 = v - 2 * (vx * n(1) + vy * n(2)) / (n(1) ^ 2 + n(2) ^ 2) .* n;
    vx1 = v1(1);
    vy1 = v1(2);

end