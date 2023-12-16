% Problem 2
% See the custom function called rexp.m
% Number of samples to generate
n = 100000;

% Generate random numbers for lambda=1
random_numbers_lambda1 = rexp(1, n);

% Generate random numbers for lambda=2
random_numbers_lambda2 = rexp(2, n);

% Create a histogram for both cases
figure;
histogram(random_numbers_lambda1, 'Normalization', 'pdf', 'BinWidth', 0.1, 'EdgeColor', 'b', 'FaceAlpha', 0.8);
hold on;
histogram(random_numbers_lambda2, 'Normalization', 'pdf', 'BinWidth', 0.1, 'EdgeColor', 'r', 'FaceAlpha', 0.4);

% Add labels and a legend
xlabel('Random Numbers');
ylabel('Density');
legend('Lambda=1', 'Lambda=2');
title('Random Numbers from Exponential Distributions');