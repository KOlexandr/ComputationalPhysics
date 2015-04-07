% Choose kT, N (linear lattice size), and J (strength of the coupling)
% Tc = Temperature Critical = 2*J / k*ln(1+sqrt(2))
% T = Tc = 2/ln(1 + sqrt(2)) -> J = 1; k = 1
%       beta = J/kT          -> T = J / k*beta;   
% The exact value of E/N for the Ising model on a square lattice with  
% L=16 and T=Tc = 2/ ln(1 + sqrt(2)) is given by E/N = -1.453061
function ising_for_visualisation
    T = 2/log(1+sqrt(2));
    lattice_size = 128;
    J = 1;
    steps = 10^6;
    density = 0.5;
    plot_steps = 1;
    grid = sign(density - rand(lattice_size)); % random init
    beta = 1/T;
    adj = neighbors(1:lattice_size^2,lattice_size); % neighbors indicies for each spin
    energyAccumulator = 0;
    energySquaredAccumulator = 0;
    energy = 0;
    heat = zeros(1, steps);
    for j=1:steps
        for sp = 1:lattice_size^2
            s = randi(lattice_size^2); % ith spin
            e_old = -J*grid(s) * sum(grid(adj(s,:)));
            e_new = J*grid(s) * sum(grid(adj(s,:)));
            dE = e_new - e_old; % change in energy of flipping s
            if dE <= 0
                grid(s) = -grid(s); 
                energy = energy + dE;
            else
                w = exp(-beta*dE);
                if rand() <= w
                    grid(s) = -grid(s); 
                    energy = energy + dE;
                end
            end
        end
        
        energyAccumulator = energyAccumulator + energy;
        energySquaredAccumulator = energySquaredAccumulator + energy * energy;
        v = 1 / (j * lattice_size^2);
        heat(j) = (energySquaredAccumulator/j - (energyAccumulator/j)^2) / (T^2) / (lattice_size^2);
        if mod(j,plot_steps)==0,
            axis square;
            title(['step: ', num2str(j), ' E/N : ', num2str(energyAccumulator*v), ' C/N : ', num2str(heat(j))])
            pause(0.01)
            colormap(gray(2));
            image((grid+1)/2+1)
        end 
    end
end