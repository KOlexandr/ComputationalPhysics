function prj_7_40_b
    
    function lines = init_random(N)
        fact = 10;
        lines = floor(fact * rand(N,1)) + 1;
    end

    function lines = init_scatter(N,totalMass)
        function x = get_rand_1_to_n(n)
            x = floor(n*rand())+1;
        end
        
        part = 10;        
        if (totalMass < N)
            lines = ones(totalMass,1);
            return;
        end
        lines = ones(N,1);
        totalMass = totalMass - N;
        
        while(totalMass > part)
            tmp = get_rand_1_to_n(part);
            totalMass = totalMass - tmp;
            lines(get_rand_1_to_n(N)) = lines(get_rand_1_to_n(N)) + tmp;
        end
        lines(get_rand_1_to_n(N)) = lines(get_rand_1_to_n(N)) + totalMass;
    end


N = 5;
% lines = init_random(N);
lines = init_scatter(N,5000);

bar(lines);
pause(1);

lines1 = lines;
lines2 = lines;
lines3 = lines;
N1 = N;
N2 = N;
N3 = N;

maxiter = 50;
for i=1:maxiter
    [lines1,N1] = step(lines1,N1);
    [lines2,N2] = step(lines2,N2);
    [lines3,N3] = step(lines3,N3);        
end
max1 = max(lines1);
max2 = max(lines2);
max3 = max(lines3);
maximum = max([max1 max2 max3]);
maxN = max([N1 N2 N3]);
if(maximum ~= max1)    
    fact1 = maximum/max1;
    for i=1:length(lines1)
        lines1(i) = floor(lines1(i)*fact1)+1;
    end
end
if(maximum ~= max2)    
    fact2 = maximum/max2;
    for i=1:length(lines2)
        lines2(i) = floor(lines2(i)*fact2)+1;
    end
end
if(maximum ~= max3)    
    fact3 = maximum/max3;
    for i=1:length(lines3)
        lines3(i) = floor(lines3(i)*fact3)+1;
    end
end
R = zeros(3,maxN);
for j=1:N1
    R(1,j) = lines1(j);
end
for j=1:N2
    R(2,j) = lines2(j);
end
for j=1:N3
    R(3,j) = lines3(j);
end
bar(R',1);


end


function [lines,N] = step(lines,N)
    [lines,N] = rand_walk(lines,N);
    [lines,N] = separate(lines,N);
end

function [lines,N] = rand_walk(lines,N)
     j = 1;
    while (j <= N)
        if (rand() > 0.5)
            shift = 1;
        else
            shift = -1;
        end
        lines(j) = lines(j) + shift;
        if (lines(j) == 0)
            lines(j) = lines(N);
            lines = lines(1:end-1);
            N = N - 1;
        end
        j = j + 1;
    end
    if (N == 0)
        disp('0 lines');
        return;
    end
end

function [lines,N] = separate(lines,N)
    totalLength = sum(lines);
    lineNo = rand();
    j = 1;
    s = 0;
    while(s < lineNo)
        s = s + lines(j)/totalLength;
        j = j + 1;
    end
    lineNo = j-1;
    if(lineNo > N)
        lineNo = N;
    end
    
    if(lines(lineNo) < 2)
        return;
    end    
    newLine = round(lines(lineNo)*rand());
    if (not((newLine == lines(lineNo)) || (newLine == 0)))
        lines(lineNo) = lines(lineNo) - newLine;
        lines = [lines; newLine];
        N = N + 1;
    end
end

