function random_numbers = rnorm(mean, std, n)
    if std <= 0
        error('Standard deviation must be positive');
    end
    
    % Generate uniform random numbers
    uniform_nums = rand(1, n);
    
    % Use transformation method to generate random numbers from normal
    % distribution
    random_numbers = mean + std * sqrt(2) * erfinv(2 * uniform_nums - 1);
end