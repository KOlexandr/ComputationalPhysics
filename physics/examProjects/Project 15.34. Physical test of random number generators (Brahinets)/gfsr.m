% X_n = X_(n-250) (+) X_(n-103)
function nums = gfsr(max, count)
    nums = cat(1, randi(2^31-1, 250, 1), zeros(count, 1));
    
    for i = 251:count+250
        nums(i) = bitxor(nums(i-250), nums(i-103));
    end
    
    nums = nums(251:length(nums));
    
    if max == 1
        nums = nums / (2^31-1);
    else
        nums = mod(nums, max) + 1;
    end 
end