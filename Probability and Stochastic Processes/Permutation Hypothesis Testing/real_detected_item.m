seed = 333;

% Set the seed for the random number generator
rng(seed);

% Define means
mean_alpha = 8.12e5; % decay per second
mean_gamma = 0.43e5;

% Generate random exponential variables
num_samples_alpha = 18;
num_samples_gamma = 10;

alpha = exprnd(mean_alpha, num_samples_alpha, 1);
gamma = exprnd(mean_gamma, num_samples_gamma, 1);

% % Combine alpha and gamma
combined = [alpha; gamma];

% Add Gaussian noise
noise_mean = 0.30*mean_gamma;
noise_std = 0.2;
noise = noise_mean + noise_std * randn(size(combined));

% Add noise to the combined data
combined_with_noise = combined + noise;

% Plot histogram of combined data
figure;
histogram(combined_with_noise, 'NumBins', 5, 'Normalization', 'count');
title('Measured particles');
xlabel('Decay (second)');
ylabel('Counts');