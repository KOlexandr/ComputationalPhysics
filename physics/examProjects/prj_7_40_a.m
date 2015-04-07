function prj_7_40_a

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


N = 20;
lines = init_scatter(N,5000);

bar(lines);
pause(1);

maxiter = 50;
for i=1:maxiter
    [lines,N] = step(lines,N);
    
    if (mod(i,10) == 0)
        disp(sum(lines));
    end
    % disp(i);
    
    bar(lines);
    pause(0.2);
end
if(N ~= 0)
    bar(lines);
end

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

