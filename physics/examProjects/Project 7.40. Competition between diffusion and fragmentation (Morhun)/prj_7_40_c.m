function prj_7_40_c
    
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
    
    function lines = init_equi_dist(N,part)
        lines = ones(N,1)*part;                
    end


N = 20;
% lines = init_random(N);
lines = init_equi_dist(N,10);
M = N;
linesM = floor(lines.*lines.^(1/3))+ones(M,1);


bar(lines);
pause(1);

maxiter = 50;
for i=1:maxiter
    [lines,N] = step(lines,N);
    [linesM,M] = step(linesM,M);
%     if (mod(i,50) == 0)
%         disp(sum(lines));
%     end
    % disp(i);
    
    %bar(lines);
    %pause(0.5);
end
% if(N ~= 0)
%     bar(lines);
%     figure;
%     plot(lines);
% end
% if(M ~= 0)
%     figure;
%     bar(linesM,'r');
%     figure;
%     plot(linesM,'r');
% end
subplot(2,2,1);plot(lines);
subplot(2,2,2);plot(linesM,'r');
subplot(2,2,3);bar(lines);
subplot(2,2,4);bar(linesM,'r');
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

