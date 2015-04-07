%  The 1-Dimension Voter Model
%  2 neighbours lattice
%  p_0 - initial density (-1 if random)
%
%  Yaroslav Brahinets 2015

function voter_model_1d
    tests = 100;
    sites_count = 10;
    max_steps_count = sites_count^3;
    p_0 = 0.51;
    total = voter_model_1d_(p_0, sites_count, max_steps_count, tests);
    fprintf('\nAvverage steps for lattice with %d sites in %d tests: %d\n', sites_count, tests, floor(total / tests));    
end


function total = voter_model_1d_(p_0, sites_count, max_steps_count, tests)
    test = 1;
    total = 0;
    while test <= tests       
        lattice = init_latice(sites_count, p_0);
        step = 0;
        while ~consensus(lattice) && step < max_steps_count
            index = randi(numel(lattice));
            index_n = get_random_neighbour(lattice, index);
            lattice(index) = lattice(index_n);
            step = step + 1;
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


function l = init_latice(sites_count, density)
    if density ~= -1
        l = zeros(1, sites_count);
        while get_density(l) < density
            l(randi(numel(l))) = 1;
        end  
    else
        l = randi([0 1], 1, sites_count);
    end
end


function d = get_density(matrix)
    d = sum(matrix(:)) / numel(matrix);
end


function c = consensus(matrix)
    c = numel(unique(matrix)) == 1;
end


function idx = get_random_neighbour(lattice, index)
    direction = randi([1, 2]);
    elems = numel(lattice);
    switch direction
        case 1 % left
            idx = index - 1;
            if idx == 0
                idx = elems;
            end
        case 2 % right
            idx = index + 1;
            if idx > elems
                idx = 1;
           end
    end
end