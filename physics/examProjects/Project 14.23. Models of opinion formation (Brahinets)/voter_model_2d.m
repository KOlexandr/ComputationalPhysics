%  The 2-Dimension Voter Model
%  4 neighbours lattice
%  p_0 - initial density (-1 if random)
%
%  Yaroslav Brahinets 2015

function voter_model_2d
    global print_info use_periodic_boundaries;
    print_info = false;
    use_periodic_boundaries = true;
    
    tests = 100;
    sites_count = 10;
    max_steps_count = sites_count^3;
    p_0 = 0.5;
    total = voter_model_2d_(p_0, sites_count, max_steps_count, tests);
    fprintf('\nAvverage steps for lattice with %d sites in %d tests: %d\n', sites_count, tests, floor(total / tests));    
end

function total = voter_model_2d_(p_0, sites_count, max_steps_count, tests)
    only_to_up = true;
    test = 1;
    total = 0;
    draw_by_steps = false;
    draw_steps = 1000;
    colormap(gray(2));
    while test <= tests    
        lattice = init_latice(sites_count, p_0);
        step = 1;
        while ~consensus(lattice) && step < max_steps_count
            if draw_by_steps
                w = waitforbuttonpress;
            else
                w = 1;
            end
            
            if w == 1
                index = randi(numel(lattice));
                val = get_random_neighbour(lattice, index);
                
                if ~only_to_up || (only_to_up && val == 2)
                    lattice(index) = val;
                    if mod(step, draw_steps) == 0
                        figure(1);
                        image(lattice)
                        axis square;
                        title(['test: ',num2str(test),'; step: ', num2str(step)])
                        pause(0.0001)
                    end
                end
                
                step = step + 1;
            end
        end
        if step ~= max_steps_count          
            fprintf('%d\t', test);
            if mod(test, 10) == 0
                fprintf('\n');
            end
            test = test + 1;
            total = total + step;
        end
    end
end

function lattice = init_latice(sites_count, density)
    if density ~= -1
        lattice = ones(sites_count);
        while get_density(lattice) < density+1;
            lattice(randi(numel(lattice))) = 2;
        end
    else
        lattice = randi([1 2], sites_count, sites_count);
    end
end


function d = get_density(matrix)
    d = sum(matrix(:)) / numel(matrix);
end


function c = consensus(matrix)
    c = numel(unique(matrix)) == 1;
end


function n = get_random_neighbour(lattice, index)
    global print_info use_periodic_boundaries;
    [rows, cols] = size(lattice);
    [col, row] = ind2sub(size(lattice),index);
    direction = randi([1, 4]);
    
    if use_periodic_boundaries
        row_low = rows;
        col_low = cols;
        row_top = 1;
        col_top = 1;
    else
        row_low = 1;
        col_low = 1;
        row_top = rows;
        col_top = cols;
    end
    
    switch direction
        case 1 % y+
            row = row + 1;        
            if row > rows
                row = row_top;
            end
            if print_info
                fprintf('UP\n');
            end;
        case 2 % % y-
            row = row - 1;
            if row == 0
                row = row_low;
            end
            if print_info
                fprintf('DOWN\n');
            end;
        case 3 % x+
            col = col - 1;
            if col == 0
                col = col_low;
            end
            if print_info
                fprintf('LEFT\n');
            end;
        case 4 % x-
            col = col + 1;
            if col > cols
                col = col_top;
            end
            if print_info
                fprintf('RIGHT\n');
            end;
    end
    
    n = lattice(col, row);
%      sub2ind(size(lattice), col, row, zow)
end