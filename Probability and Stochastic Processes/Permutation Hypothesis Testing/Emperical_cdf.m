seed = 333;

% Set the seed for the random number generator
rng(seed);

% Define theoretical parameters
% Define means
mean_alpha_theoretical = 8.12e5; % decay time
mean_gamma_theoretical = 0.43e5;

% Generate random exponential variables
num_samples_alpha_theoretical = 2.54e2;
num_samples_gamma_theoretical = 1.27e2;

alpha_theoretical = exprnd(mean_alpha_theoretical, num_samples_alpha_theoretical, 1);
gamma_theoretical = exprnd(mean_gamma_theoretical, num_samples_gamma_theoretical, 1);

% Combine alpha and gamma
combined_theoretical = [alpha_theoretical; gamma_theoretical];

% Define measured parameters
% Define means
mean_alpha = 8.12e5; % decay time
mean_gamma = 0.43e5;

% Generate random exponential variables
num_samples_alpha = 14;
num_samples_gamma = 6;

alpha = exprnd(mean_alpha, num_samples_alpha, 1);
gamma = exprnd(mean_gamma, num_samples_gamma, 1);

% Combine alpha and gamma
combined = [alpha; gamma];

% Add Gaussian noise
noise_mean = mean_gamma*0.30;
noise_std = 0.20;
noise = noise_mean + noise_std * randn(size(combined));

% Add noise to the combined data
combined_with_noise = combined + noise;

% Plot empirical CDFs
figure;
hold on;

% Empirical CDF for uranium
h1 = cdfplot(combined);
set(h1, 'Color', 'b', 'LineWidth', 1.5);

% Empirical CDF for measured particles
h2 = cdfplot(combined_with_noise);
set(h2, 'Color', 'r', 'LineWidth', 1.5)

% Customize the plot
title('Empirical CDF for Uranium and Measured Particles');
xlabel('Decay (second)');
ylabel('Cumulative Probability');

% Set legend in lower right corner
legend('Uranium', 'Measured particles', 'Location', 'southeast');

hold off;