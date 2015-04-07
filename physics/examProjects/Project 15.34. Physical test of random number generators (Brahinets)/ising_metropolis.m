% Choose kT, N (linear lattice size), and J (strength of the coupling)
% Tc = Temperature Critical = 2*J / k*ln(1+sqrt(2))
% T = Tc = 2/ln(1 + sqrt(2)) -> J = 1; k = 1
%       beta = J/kT          -> T = J / k*beta;   
% The exact value of E/N for the Ising model on a square lattice with  
% L=16 and T=Tc = 2/ ln(1 + sqrt(2)) is given by E/N = -1.45306
% T+ -> E+ -> M-

function ising_metropolis
    tic
    T = 2/log(1+sqrt(2));
    L = 16;
    J = 1;
    k = 1;
    steps = 10^5;
    density = 0.5;
    beta = 1/(k*T);
    adj = neighbors(1:L^2,L); % neighbors indicies for each spin
    tests = 10;
    a = 16807; 
    m = 2^31 - 1;
    c = 0;
    mean_energy_per_spin = zeros(1, tests);
    mean_heat_per_spin = zeros(1, tests);
    fprintf('\nIsing test using GFSR generator and Metropolis. steps : %d \n', steps*10);
    for i=1:tests
        energyAccumulator = 0;
        energySquaredAccumulator = 0;
        heat_= zeros(1,steps);
        energy_ = zeros(1,steps);
        fprintf('%d\t',i); 
        grid = sign(density - rand(L)); % random init
        energy = 0;
        for j=1:steps
            spin = randi(L^2,1, L^2); % 1 and imax.
            %spin = lgc(a, c, m, randi(2^31-1), L^2, L^2);
            spin = gfsr(L^2, L^2);

            randoms = rand(1, L^2);
            %randoms = lgc(a, c, m, randi(2^31-1), 1, L^2);
            %randoms = gfsr(1, L^2);
            for sp = 1:L^2
                s = spin(sp); % ith spin
                e_old = -J*grid(s) * sum(grid(adj(s,:)));
                e_new = J*grid(s) * sum(grid(adj(s,:)));
                dE = e_new - e_old; % change in energy of flipping s
                if dE <= 0
                    grid(s) = -grid(s); 
                    energy = energy + dE;
                else
                    w = exp(-beta*dE);
                    if randoms(sp) < w
                        grid(s) = -grid(s); 
                        energy = energy + dE;
                    end
                end
            end

            energyAccumulator = energyAccumulator + energy;
            energySquaredAccumulator = energySquaredAccumulator + energy * energy;
            heat_(j) = (energySquaredAccumulator/j - (energyAccumulator/j)^2) / (T^2) / (L^2);
            energy_(j) = energyAccumulator / (j * L^2);
        end
        mean_energy_per_spin(i) = sum(energy_)/steps;
        mean_heat_per_spin(i) = sum(heat_)/steps;
    end
    % C = (<E^2> - <E>^2) / T^2;    
    deviation_standart_e = sum((mean_energy_per_spin - sum(mean_energy_per_spin)/tests).^2)/(tests-1);
    deviation_standart_e_mean = sqrt(deviation_standart_e);
    deviation_standart_c = sum((mean_heat_per_spin - sum(mean_heat_per_spin)/tests).^2)/(tests-1);
    deviation_standart_c_mean = sqrt(deviation_standart_c);

    mean_energy_per_spin = sum(mean_energy_per_spin) / tests;
    mean_heat_per_spin = sum(mean_heat_per_spin) / tests;

    delta_e = abs(mean_energy_per_spin - -1.45306);
    delta_c = abs(mean_heat_per_spin - 1.49871);
    res_e = delta_e / deviation_standart_e_mean;
    res_c = delta_c / deviation_standart_c_mean;
    
    fprintf('\nRatio for E : %f, Mean Energy : %f', res_e, mean_energy_per_spin);
    fprintf('\nRatio for C : %f, Mean Heat : %f \n\n', res_c, mean_heat_per_spin);
    toc
end