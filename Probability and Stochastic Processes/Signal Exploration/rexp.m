function random_numbers = rexp(lambda, n)
    if lambda <= 0
        error('Lambda must be positive');
    end
    
    % Generate uniform random numbers
    uniform_nums = rand(1, n);
    
    % Use the inverse transform method to generate random numbers from
    % the exponential distribution
    random_numbers = -log(1 - uniform_nums) / lambda;
end