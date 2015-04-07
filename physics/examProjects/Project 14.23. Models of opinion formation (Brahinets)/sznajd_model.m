%  Sznajd Model
%  4 neighbours lattice
%
%  Yaroslav Brahinets 2015

function sznajd_model
    clear all
    close all
    global print_info use_periodic_boundaries;
    print_info = false;
    use_periodic_boundaries = true;
    draw_by_steps = false;
    tests = 10;
    test = 1;
    total = 0;
    sites_count = 20;
    max_steps_count = 100000;
    opinion_count = 2;
    draw_steps = 5000;
    colormap(gray(opinion_count));
    densities = [0.505, 0.525, 0.550];
    density = densities(3);
    
    while test <= tests    
        lattice = init_latice(sites_count, opinion_count, density);
        step = 0;
        while  ~consenus(lattice) && step < max_steps_count
            if draw_by_steps
                w = waitforbuttonpress;
            else
                w = 1;
            end

            if w == 1             
                index_1 = randi(numel(lattice));
                index_2 = get_random_neighbour(lattice, index_1);
                lattice = change_neighbours(lattice, index_1, index_2, lattice(index_1) == lattice(index_2));
                step = step + 1;

                if mod(step, draw_steps) == 0
                    figure(1);
                    image(lattice)
                    axis square;
                    title(['test: ',num2str(test),'; step: ', num2str(step)])
                    pause(0.0001)
                end            
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
    total = floor(total / tests);
    fprintf('\nAvverage steps for lattice, with %d sites in %d tests: %d\n', numel(lattice), tests, total);    
end


function l = init_latice(sites_count, opinions_count, density)
    if opinions_count == 2
        l = ones(sites_count);
        current_density = 0;
        while current_density < density+1;
            l(randi(numel(l))) = 2;
            current_density = get_density(l);
        end  
    else
        l = randi([1 opinions_count], sites_count, sites_count);
    end
end


function d = consenus(matrix)
    d = numel(unique(matrix)) == 1;
end


function l = change_neighbours(prev_lattice, index_1, index_2, equality)
    l = prev_lattice;
    if equality
        val_i = l(index_1);
        l = set_neigbours(l, index_1, val_i);
        l = set_neigbours(l, index_2, val_i);
    end
end


function d = get_density(matrix)
    d = (sum(matrix(:))) / numel(matrix);
end


function lattice = set_neigbours(lattice, index, val)
    [rows, cols] = size(lattice);
    [col, row] = ind2sub(size(lattice), index);
    [row_low, row_top, col_low, col_top] = get_bounds(lattice);

    if col - 1 == 0 % left
        lattice(row, col_low) = val;
    else
        lattice(row, col - 1) = val;
    end
    
    if col + 1 > cols % right
        lattice(row, col_top) = val;
    else
        lattice(row, col + 1) = val;
    end

    if row - 1 == 0 % bottom
        lattice(row_low, col) = val;
    else
        lattice(row - 1, col) = val;
    end 
    
    if row + 1 > rows % top
        lattice(row_top, col) = val;
    else
        lattice(row + 1, col) = val;
    end
end

function n = get_random_neighbour(lattice, index)
    global print_info;
    [rows, cols] = size(lattice);
    [col, row] = ind2sub(size(lattice),index);
    direction = randi([1, 4]);
    [row_low, row_top, col_low, col_top] = get_bounds(lattice);

    if direction == 1 % y+
        row = row + 1;        
        if row > rows
            row = row_top;
        end
        if print_info
            fprintf('UP\n');
        end;
    end
    
    if direction == 2 % y-
        row = row - 1;
        if row == 0
            row = row_low;
        end
        if print_info
            fprintf('DOWN\n');
        end;
    end
      
    if direction == 3 % x-
        col = col - 1;
        if col == 0
            col = col_low;
        end
        if print_info
            fprintf('LEFT\n');
        end;
    end
    
    if direction == 4 % x+
        col = col + 1;
        if col > cols
            col = col_top;
        end
        if print_info
            fprintf('RIGHT\n');
        end;
    end
    
    n = sub2ind(size(lattice), col, row);
end


function [row_low, row_top, col_low, col_top] = get_bounds(lattice)
    global use_periodic_boundaries;
    [rows, cols] = size(lattice);
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
end