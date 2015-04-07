%  Relative agreement interaction model
%  4 neighbours lattice
%
%  Yaroslav Brahinets 2015

function relative_agreement_interaction_model
    clear all
    close all
    draw_by_steps = false;
    tests_count = 10;
    total_steps = 0;
    max_steps_count = 5000;
    sites_count = 10;
    draw_steps = 100; 
    opinions_count = 256;
    e_list = [5, 10, 50, 100]; % extremist power
    m_list = [0.3, 0.6];
    e = e_list(4);
    m = m_list(2);
    
    current_test = 1;
    while current_test <= tests_count    
         lattice = init_latice(sites_count, opinions_count);
         step = 0;
         while consenus(lattice) == false && step < max_steps_count
            if draw_by_steps
                w = waitforbuttonpress;
            else
                w = 1;
            end
           
            if w == 1
                [i, j] = get_random_indexes(lattice);
                o_i = lattice(i);
                o_j = lattice(j);
                if o_i - o_j < e
                    lattice(i) = ceil(lattice(i) - (m/2)*(o_i - o_j));
                    lattice(j) = ceil(lattice(j) + (m/2)*(o_i - o_j));
                end

                step = step + 1;
                if mod(step, draw_steps) == 0
                    figure(1);
                    colormap(gray(opinions_count));
                    image(lattice);
                    axis square;
                    title(['test: ',num2str(current_test),'; step: ', num2str(step)]);
                    pause(0.1);
                end
            end
         end
         if step ~= max_steps_count
             fprintf('%d\t', current_test);
             if mod(current_test, 10) == 0
                 fprintf('\n');
             end
             current_test = current_test + 1;
             total_steps = total_steps + step;
         end
     end
     total_steps = floor(total_steps / tests_count);
     fprintf('\nAvverage steps for lattice, with %d sites and %d opinions in %d tests: %d\n', numel(lattice), opinions_count, tests_count, total_steps);    
end


function l = init_latice(sites_count, opinions_count)
    l = randi ([1 opinions_count], sites_count, sites_count);
end


function [i, j] = get_random_indexes(lattice)
    i = randi(numel(lattice));
    j = randi(numel(lattice));
    while i == j || lattice(i) <= lattice(j)
        i = randi(numel(lattice));
        j = randi(numel(lattice));
    end
end


function d = consenus(matrix)
  d = numel(unique(matrix)) == 1;
end