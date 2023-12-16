% Problem 1
% See the custom function called rnorm.m
% Number of samples to generate
n = 100000;

% Generate random numbers for mean=0, std=1
random_numbers_std1 = rnorm(0, 1, n);

% Generate random numbers for mean=0, std=2
random_numbers_std2 = rnorm(0, 2, n);

% Create a histogram for both cases
figure;
histogram(random_numbers_std2, 'Normalization', 'pdf', 'BinWidth', 0.1, 'EdgeColor', 'b', 'FaceAlpha', 0.8);
hold on;
histogram(random_numbers_std1, 'Normalization', 'pdf', 'BinWidth', 0.1, 'EdgeColor', 'r', 'FaceAlpha', 0.4);

% Add labels and a legend
xlabel('Random Numbers');
ylabel('Density');
legend('Mean=0, Std=2', 'Mean=0, Std=1');
title('Random Numbers from Normal Distributions');