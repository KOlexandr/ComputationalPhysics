function prj_7_40
    
N = 10;
fact = 10;
lines = floor(fact * rand(N,1)) + 1;



maxiter = 1500;
for i=1:maxiter
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
        break;
    end
    
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
        continue;
    end    
    newLine = round(lines(lineNo)*rand());
    if (not((newLine == lines(lineNo)) || (newLine == 0)))
        lines(lineNo) = lines(lineNo) - newLine;
        lines = [lines; newLine];
        N = N + 1;
    end
    
    %bar(lines);
    disp(i);
    %pause(1);
end
if(N ~= 0)
    bar(lines);
end

end