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

% Perform t-test
[s1_simple, mu1_simple, n1_simple, df_simple, t_stat_simple, p_value_simple] = one_sample_t_test(combined_with_noise, mean(combined_theoretical));

% Perform Welch's t-test
[s1, s2, mu1, mu2, n1, n2, df, t_stat, p_value] = welch_t_test(combined_theoretical, combined_with_noise);

% Run the permutation test for comparing CDFs
num_permutations = 1000;  % Set the number of permutations
[observed_statistic, p_value_permutation] = permutation_test_cdfs(combined_with_noise, combined_theoretical, num_permutations);