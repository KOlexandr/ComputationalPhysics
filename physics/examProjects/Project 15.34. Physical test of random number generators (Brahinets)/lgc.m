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