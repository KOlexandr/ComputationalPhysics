% Choose kT, N (linear lattice size), and J (strength of the coupling)
% Tc = Temperature Critical = 2*J / k*ln(1+sqrt(2))
% T = Tc = 2/ln(1 + sqrt(2)) -> J = 1; k = 1
%       beta = J/kT          -> T = J / k*beta;   
% The exact value of E/N for the Ising model on a square lattice with  
% L=16 and T=Tc = 2/ ln(1 + sqrt(2)) is given by E/N = -1.45306

function ising_wolf
    tic
    T = 2/log(1+sqrt(2));
    L = 16;
    J = 1;
    steps = 10^3; % should be 10^6 but veeeeery slow, all night
    density = 0.5;
    k = 1;
    beta = 1/(k*T);
    adj = neighbors(1:L^2,L); % neighbors indicies for each spin
    tests = 10;
    a = 16807; 
    m = 2^31 - 1;
    c = 0;
    mean_energy_per_spin = zeros(1, tests);
    mean_heat_per_spin = zeros(1, tests);
    fprintf('\nIsing test using LCG generator and Wolf. steps : %d \n', steps*10);
    p = 1-exp(-beta*J);

    for i=1:tests
        energyAccumulator = 0;
        energySquaredAccumulator = 0;
        heat_= zeros(1,steps);
        energy_ = zeros(1,steps);
        fprintf('%d\t',i); 
        grid = sign(density - rand(L)); % random init
        energy = 0;
        for j=1:steps
            spin = lgc(a, c, m, randi(2^31-1), L^2, L^2);
            randoms = lgc(a, c, m, randi(2^31-1), 1, L^2);
            for sp = 1:1
                s = spin(sp); % ith spin
                e_old = isingenergy(grid,J);
                C = one_wolff(L,p,grid,adj, s, randi(2^31-1));
                grid(C) = -1*grid(C);         
                e_new = isingenergy(grid,J);                
                dE = e_new - e_old; % change in energy of flipping s
                if dE <= 0
                    energy = energy + dE;
                else
                    w = exp(-beta*dE);
                    if randoms(sp) < w
                        energy = energy + dE;
                    else
                        grid(C) = -1*grid(C); 
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

function C = one_wolff(L,p,grid,adj, i, seed)
    C = i; % the cluster
    F = i; % the frontier of spins
    s = grid(i); % seed spin direction
    Ci = zeros(L^2,1); % indicator function for cluster elements

    while ~isempty(F),
        F = adj(F,:); % Compute the new neighboring spins
        F = F(grid(F(:)) == s);% only choose ones parallel to the seed spin
        % find elements that aren't in the cluster
        Fi=zeros(L^2,1);% indicator function for the frontier spins
        Ci(C)=1; Fi(F)=1;
        F = find(Fi-Ci>0);
        randoms = rand(1, length(F));       

        if ~isempty(F)
            randoms = lgc(seed, 1, length(randoms), randi(2^31-1), L^2, L^2);
        end
        
       F = F(randoms<p); % keep spins only with probability p
       C(end+1:end+length(F')) = F;% add to cluster
    end
end


function energy = isingenergy(grid,J)
    neighbors = circshift(grid,[0 1]) + circshift(grid,[0 -1]) + ... 
                circshift(grid,[1 0]) + circshift(grid,[-1 0]);
    energy = -1/2*J*sum(sum(grid.*neighbors));
end

% Linear Congruential Generators 
% x the initial seed, 0 <= c < m 
% a the multiplier, 0 <= a < m, normally greater than 1 
% c the increment 0 <= c < m 
% m the modulus, prime numbers are best 


% X_n = (a * X_(n-1) + c) mod m
% there used Park-Miller numbers
function nums = lgc(a, c, m, seed, max, count)
    nums = zeros(count, 1);
    nums(1) = mod(a * seed + c, m);
    
    for n = 2:count,
      nums(n) = rem(a * nums(n - 1) + c, m);
    end
   
    if max == 1
        nums = nums / m;
    else
        nums = mod(nums, max) + 1;
    end 
end

% take a list of linear indices s and return the linear indices of the
% neighbors of s on an N by N grid with periodic boundary conditions.
function adj = neighbors(s,N)
    s = s-1; % index by zero
    adj = zeros(length(s),4);

    % s = r*N+c;
    r = floor(s/N);
    c = rem(s,N);

    adj(:,1) = mod(r+1,N)*N+c;  %down
    adj(:,2) = mod(r-1,N)*N+c;  %up
    adj(:,3) = r*N+mod(c+1,N);  %right
    adj(:,4) = r*N+mod(c-1,N);  %left

    adj = adj+1; % index by one again
end