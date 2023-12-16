seed = 333;

% Set the seed for the random number generator
rng(seed);

% Define means
mean_alpha = 8.12e5; % decay per second
mean_gamma = 0.43e5;

% Generate random exponential variables
num_samples_alpha = 2.54e2;
num_samples_gamma = 1.27e2;

alpha = exprnd(mean_alpha, num_samples_alpha, 1);
gamma = exprnd(mean_gamma, num_samples_gamma, 1);

% Combine alpha and gamma
combined = [alpha; gamma];

% Plotting in subplots
figure;

% Subplot 1 for alpha
subplot(1, 3, 1);
histogram(alpha, 'Normalization', 'count', 'FaceAlpha', 0.5, 'DisplayName', 'Alpha', 'FaceColor', 'r');
title('Alpha Particles');
xlabel('Decay (second)');
ylabel('Counts');

% Subplot 2 for gamma
subplot(1, 3, 2);
histogram(gamma, 'Normalization', 'count', 'FaceAlpha', 0.5, 'DisplayName', 'Gamma', 'FaceColor', 'g');
title('Gamma Particles');
xlabel('Decay (second)');
ylabel('Counts');

% Subplot 3 for combined
subplot(1, 3, 3);
histogram(combined, 'Normalization', 'count', 'FaceAlpha', 0.5, 'DisplayName', 'Combined');
title('Combined (Mixed Distribution)');
xlabel('Decay (second)');
ylabel('Counts');

% Adjust the layout
sgtitle('Theoretical Uranium');