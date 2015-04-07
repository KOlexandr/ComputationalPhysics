function stat_tests 
    %period_test % a    
    %uniformity_test % b
    % chi_squares_test  % c
    % filling_test %d
    % parking_lots_test % e    
    random_walk_test % h
end


function period_test
    % period be much greater than the number of random numbers needed in a specific calculation
    count = 10^4;
    m = 32768;
    nums_lcg = lgc(899, 0, m, 12, 1, count);    
    nums_gfsr = gfsr(1, count);    
    nums_matlab = randi(count, 1, count);    
    nums = nums_lcg;
    % find out the period 
    i=1; 
    j=2; 
    
    while nums(i) ~= nums(j) && j < numel(nums)
        if j > m  % integer nums_lcg(i) doesn?t repeat in the sequence 
            i=i+1;  % see if the next integer repeats or not 
            j=i; 
        end; 
        j=j+1;
    end; 
    if(j ~= numel(nums))
        p = j-i; 
        oneperiod = nums(i:i+p);   % one period and three integers
    else
        p = -1;
    end
    fprintf('Period : %d\n\n', p);
end


function uniformity_test
    % random number sequence should contain numbers distributed in the unit interval with equal probability
    count = 10^6;
    bins = 100;
    interval_len = 1/bins;
    nums_lcg = lgc(106, 6075, 1283, 12, 1, count);
    nums_gfsr = gfsr(1, count);
    nums_matlab = rand(1, count);
    in_ranges = zeros(bins, 3);
    for i=1:bins
        in_ranges(i, 1) = numel(nums_lcg(nums_lcg(:)>(i-1)*interval_len & nums_lcg(:)<i*interval_len ));
        in_ranges(i, 2) = numel(nums_gfsr(nums_gfsr(:)>(i-1)*interval_len & nums_gfsr(:)<i*interval_len ));
        in_ranges(i, 3) = numel(nums_matlab(nums_matlab(:)>(i-1)*interval_len & nums_matlab(:)<i*interval_len ));
    end
    plot(1:bins,in_ranges(:, 1),'r',1:bins,in_ranges(:, 2),'b',1:bins,in_ranges(:, 3),'k');
    axis([1 bins 0 max(max(in_ranges))]);
    title(['Uniformity Distribution of ', num2str(count), ' numbers, in ', num2str(bins), ' beans']);
    legend('LCG','GFSR','Matlab')
    xlabel('Bin number');
    ylabel('Numbers count in bin');
end
 

function chi_squares_test
    % chi^2 = sum_M_((y(i) - E(i))^2 / E(i))
    % good if chi^2 <= E, 
    %
    % Chi LGC : 936.877400
    % Chi GFSR : 127.865200
    % Chi Matlab : 100.271000
    count = 10^6;
    bins = 100;
    E = count / bins;
    interval_len = 1/bins;
    nums_lcg = lgc(106, 6075, 1283, 12, 1, count);    
    nums_gfsr = gfsr(1, count);    
    nums_matlab = rand(1, count);    
    chi_square_lcg = zeros(1, bins);
    chi_square_gfsr = zeros(1, bins);
    chi_square_matlab = zeros(1, bins);
    for i=1:bins
        in_lcg = numel(nums_lcg(nums_lcg(:)>(i-1)*interval_len & nums_lcg(:)<i*interval_len ));
        in_gfsr = numel(nums_gfsr(nums_gfsr(:)>(i-1)*interval_len & nums_gfsr(:)<i*interval_len ));
        in_matlab = numel(nums_matlab(nums_matlab(:)>(i-1)*interval_len & nums_matlab(:)<i*interval_len ));
        
        chi_square_lcg(i) = ((in_lcg - E)^2)/E;
        chi_square_gfsr(i) = ((in_gfsr - E)^2)/E;
        chi_square_matlab(i) = ((in_matlab - E)^2)/E;
    end
    
    fprintf('Chi LGC : %f\n', sum(chi_square_lcg));
    fprintf('Chi GFSR : %f\n', sum(chi_square_gfsr));
    fprintf('Chi Matlab : %f\n\n', sum(chi_square_matlab));
end 


function filling_test
    % Made 50 steps with lattice size = 10x10 
    % LGC percent of 0 number : 59.434000, expected 60.653066
    % GFSR percent of 0 number : 60.394000, expected 60.653066
    % Matlab percent of 0 number : 60.416000, expected 60.653066
    lattice_size = 10;
    steps = 50;
    tests = 1000;
    count_lcg = 0;
    count_gfsr = 0;
    count_matlab = 0;
    for test = 1:tests
        nums_lcg = lgc(106, 6075, 1283, randi(2^31-1), 1, steps*2);
        nums_gfsr = gfsr(1, steps*2);    
        nums_matlab = rand(1, steps*2);    
        lcg_nums = [nums_lcg(1:2:steps*2).*(2^31-1), nums_lcg(2:2:steps*2).*(2^31-1)];
        gfsr_nums = [nums_gfsr(1:2:steps*2).*(2^31-1), nums_gfsr(2:2:steps*2).*(2^31-1)];
        matlab_nums = [[nums_matlab(1:2:steps*2).*(2^31-1)]', [nums_matlab(2:2:steps*2).*(2^31-1)]'];
        lattice_lcg = zeros(lattice_size);
        lattice_gfsr = zeros(lattice_size);
        lattice_matlab = zeros(lattice_size);
        for i = 1:steps
            lattice_lcg(mod(round(lcg_nums(i, 1)), lattice_size)+1, mod(round(lcg_nums(i, 2)), lattice_size)+1) = 1;
            lattice_gfsr(mod(round(gfsr_nums(i, 1)), lattice_size)+1, mod(round(gfsr_nums(i, 2)), lattice_size)+1) = 1;
            lattice_matlab(mod(round(matlab_nums(i, 1)), lattice_size)+1, mod(round(matlab_nums(i, 2)), lattice_size)+1) = 1;
        end
        count_lcg = count_lcg + nnz(lattice_lcg == 0);
        count_gfsr = count_gfsr + nnz(lattice_gfsr == 0);
        count_matlab = count_matlab + nnz(lattice_matlab == 0);
    end
    
    fprintf('Made %d steps with lattice size = %dx%d \n', steps, lattice_size, lattice_size);
    fprintf('LGC percent of 0 number : %f, expected %f\n', count_lcg / tests, exp(-steps/lattice_size^2)*100);
    fprintf('GFSR percent of 0 number : %f, expected %f\n', count_gfsr / tests, exp(-steps/lattice_size^2)*100);
    fprintf('Matlab percent of 0 number : %f, expected %f\n', count_matlab / tests, exp(-steps/lattice_size^2)*100);
end


function parking_lots_test
    % no stripes of filled sites
    count = 10^6;
    lattice_size = 10^3;
    nums_lcg = lgc(2^31-1, 0, lattice_size^3, randi(lattice_size), 1, count*2);    
    nums_gfsr = gfsr(1, count*2);    
    nums_matlab = randi(lattice_size, 1, count*2);    
    
    x_lcg = mod(round(nums_lcg(1:2:count*2).*2^31),lattice_size)+1;
    y_lcg = mod(round(nums_lcg(2:2:count*2).*2^31), lattice_size)+1;
    x_gfrs = mod(round(nums_gfsr(1:2:count*2).*2^31), lattice_size)+1;
    y_gfrs = mod(round(nums_gfsr(2:2:count*2).*2^31), lattice_size)+1;
    x_matlab = nums_matlab(1:2:count*2);
    y_matlab = nums_matlab(2:2:count*2);
    lattice_lcg = ones(lattice_size);
    lattice_gfsr = ones(lattice_size);
    lattice_matlab = ones(lattice_size);
    for i=1:count
        lattice_lcg(x_lcg(i), y_lcg (i)) = 256;
        lattice_gfsr(x_gfrs(i), y_gfrs (i)) = 256;
        lattice_matlab(x_matlab(i), y_matlab (i)) = 256;
    end
    figure(1)
    image(lattice_lcg);
    title('LCG')
    figure(2)
    image(lattice_gfsr);
    title('GFSR')
    figure(3)
    image(lattice_matlab);
    title('MATLAB')
end


function random_walk_test
    % if chi^2 > 7.815 then fail
    tic
    walkers = 10;
    bins_count = 4;
    E = walkers / bins_count;
    steps = 10^5;
    tests = 10;
    chi_lcg = 0;
    chi_gfsr = 0;
    chi_matlab = 0;
    pos_lcg = zeros(2, steps, walkers);
    pos_gfsr = zeros(2, steps, walkers);
    pos_matlab = zeros(2, steps, walkers);
    for test=1:tests
        for w = 1:walkers
            nums_lcg = lgc(106, 6075, 1283, randi(2^31-1), 1, 2*steps);
            nums_gfsr = gfsr(1, 2*steps);   
            nums_matlab = rand(1, 2*steps)';
            for s = 2:steps
                pos_lcg(1, s, w) = pos_lcg(1, s-1, w) + (nums_lcg((s-1)*2+1) > 0.5)*2-1; % x lcg
                pos_lcg(2, s, w) = pos_lcg(2, s-1, w) + (nums_lcg(s*2) > 0.5)*2-1; % y lcg
                
                pos_gfsr(1, s, w) = pos_gfsr(1, s-1, w)  + (nums_gfsr((s-1)*2+1) > 0.5)*2-1; % x gfsr
                pos_gfsr(2, s, w) = pos_gfsr(2, s-1, w)  + (nums_gfsr(s*2) > 0.5)*2-1; % y gfsr
                
                pos_matlab(1, s, w) = pos_matlab(1, s-1, w)  + (nums_matlab((s-1)*2+1) > 0.5)*2-1; % x matlab
                pos_matlab(2, s, w) = pos_matlab(2, s-1, w)  + (nums_matlab(s*2) > 0.5)*2-1; % y matlab
            end
        end
        

    %     q4 q1
    %     q3 q2
        count_of_walkers_in_bins_lcg = zeros(1, 4);
        count_of_walkers_in_bins_gfsr = zeros(1, 4);
        count_of_walkers_in_bins_matlab = zeros(1, 4);
        for walk = 1:walkers
            if pos_lcg(1, steps, walk) >= 0 && pos_lcg(2,steps,walk) >= 0  % q1
                count_of_walkers_in_bins_lcg(1) = count_of_walkers_in_bins_lcg(1) + 1;
            else if pos_lcg(1, steps, walk) >= 0 && pos_lcg(2,steps,walk) < 0  % q2
                    count_of_walkers_in_bins_lcg(2) = count_of_walkers_in_bins_lcg(2) + 1;
                else if pos_lcg(1, steps, walk) < 0 && pos_lcg(2,steps,walk) < 0  % q3
                        count_of_walkers_in_bins_lcg(3) = count_of_walkers_in_bins_lcg(3) + 1;
                    else if pos_lcg(1, steps, walk) < 0 && pos_lcg(2,steps,walk) >= 0  % q4
                            count_of_walkers_in_bins_lcg(4) = count_of_walkers_in_bins_lcg(4) + 1;
                        end
                    end
                end
            end
            
 
            if pos_gfsr(1, steps, walk) >= 0 && pos_gfsr(2, steps, walk) >= 0  % q1
                count_of_walkers_in_bins_gfsr(1) = count_of_walkers_in_bins_gfsr(1) + 1;
            else if pos_gfsr(1, steps, walk) >= 0 && pos_gfsr(2, steps, walk) < 0  % q2
                    count_of_walkers_in_bins_gfsr(2) = count_of_walkers_in_bins_gfsr(2) + 1;
                else if pos_gfsr(1, steps, walk) < 0 && pos_gfsr(2, steps, walk) < 0  % q3
                        count_of_walkers_in_bins_gfsr(3) = count_of_walkers_in_bins_gfsr(3) + 1;
                    else if pos_gfsr(1, steps, walk) < 0 && pos_gfsr(2, steps, walk) >= 0  % q4
                            count_of_walkers_in_bins_gfsr(4) = count_of_walkers_in_bins_gfsr(4) + 1;
                        end
                    end
                end
            end
            
            if pos_matlab(1, steps, walk) >= 0 && pos_matlab(2, steps, walk) >= 0  % q1
                count_of_walkers_in_bins_matlab(1) = count_of_walkers_in_bins_matlab(1) + 1;
            else if pos_matlab(1, steps, walk) >= 0 && pos_matlab(2, steps, walk) < 0  % q2
                    count_of_walkers_in_bins_matlab(2) = count_of_walkers_in_bins_matlab(2) + 1;
                else if pos_matlab(1, steps, walk) < 0 && pos_matlab(2, steps, walk) < 0  % q3
                        count_of_walkers_in_bins_matlab(3) = count_of_walkers_in_bins_matlab(3) + 1;
                     else if pos_matlab(1, steps, walk) < 0 && pos_matlab(2, steps, walk) >= 0  % q4
                            count_of_walkers_in_bins_matlab(4) = count_of_walkers_in_bins_matlab(4) + 1;
                         end
                    end
                end
            end
       end
        
        chi_square_lcg = zeros(1, bins_count);
        chi_square_gfsr = zeros(1, bins_count);
        chi_square_matlab = zeros(1, bins_count);
        for i=1:bins_count
            chi_square_lcg(i) = ((count_of_walkers_in_bins_lcg(i) - E)^2)/E;
            chi_square_gfsr(i) = ((count_of_walkers_in_bins_gfsr(i) - E)^2)/E;
            chi_square_matlab(i) = ((count_of_walkers_in_bins_matlab(i) - E)^2)/E;
        end
        
        chi_lcg = chi_lcg + sum(chi_square_lcg);
        chi_gfsr = chi_gfsr + sum(chi_square_gfsr);
        chi_matlab = chi_matlab + sum(chi_square_matlab);
        fprintf('\t%d', test);
        if mod(test, 10) == 0
            fprintf('\n');
        end
    end
    

    fprintf('\nRandom walk for %d walker, %d steps in %d tests: %f\n', walkers, steps, tests);
    fprintf('\nChi LGC : %f\n', chi_lcg / tests);
    fprintf('Chi GFSR : %f\n', chi_gfsr/tests);
    fprintf('Chi Matlab : %f\n\n', chi_matlab/tests);
    toc
end