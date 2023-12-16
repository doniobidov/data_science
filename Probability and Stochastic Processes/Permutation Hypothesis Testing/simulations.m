% Define theoretical parameters
% Define means
mean_alpha_theoretical = 8.12e5; % decay per second
mean_gamma_theoretical = 0.43e5;

% Generate random exponential variables
num_samples_alpha_theoretical = 2.54e2;
num_samples_gamma_theoretical = 1.27e2;

alpha_theoretical = exprnd(mean_alpha_theoretical, num_samples_alpha_theoretical, 1);
gamma_theoretical = exprnd(mean_gamma_theoretical, num_samples_gamma_theoretical, 1);
combined_theoretical = [alpha_theoretical; gamma_theoretical];

% Define measured parameters
% Define means
mean_alpha = 8.12e5; % decay per second
mean_gamma = 0.43e5;

% Generate random exponential variables
num_samples_alpha = 14;
num_samples_gamma = 6;

num_simulations = 5000; % Set the number of simulations
accept_null_t = 0;
accept_null_welch = 0;
accept_null_permutation = 0;

% Add Gaussian noise
noise_mean = mean_gamma*0.30;
noise_std = 0.20;

num_permutations = 1000;  % Set the number of permutations

for i = 1:num_simulations
    % Generate data
    alpha = exprnd(mean_alpha, num_samples_alpha, 1);
    gamma = exprnd(mean_gamma, num_samples_gamma, 1);
    combined = [alpha; gamma];

    noise = noise_mean + noise_std * randn(size(combined));
    combined_with_noise = combined + noise;

    % Perform t-test
    [~, ~, ~, ~, ~, p_value_simple] = one_sample_t_test(combined_with_noise, mean(combined_theoretical));
    if p_value_simple >= 0.05 % Accept null hypothesis if p-value >= 0.05
        accept_null_t = accept_null_t + 1;
    end

    % Perform Welch's t-test
    [~, ~, ~, ~, ~, ~, ~, ~, p_value_welch] = welch_t_test(combined_theoretical, combined_with_noise);
    if p_value_welch >= 0.05 % Accept null hypothesis if p-value >= 0.05
        accept_null_welch = accept_null_welch + 1;
    end

    % Run the permutation test for comparing CDFs
    [~, p_value_permutation] = permutation_test_cdfs(combined_with_noise, combined_theoretical, num_permutations);
    if p_value_permutation >= 0.05 % Accept null hypothesis if p-value >= 0.05
        accept_null_permutation = accept_null_permutation + 1;
    end
end

% Calculate the proportion of simulations where null hypothesis is accepted
proportion_accept_null_t = accept_null_t / num_simulations;
proportion_accept_null_welch = accept_null_welch / num_simulations;
proportion_accept_null_permutation = accept_null_permutation / num_simulations;

disp(['Proportion of simulations accepting null hypothesis (Simple t-test): ', num2str(proportion_accept_null_t)]);
disp(['Proportion of simulations accepting null hypothesis (Welch''s t-test): ', num2str(proportion_accept_null_welch)]);
disp(['Proportion of simulations accepting null hypothesis (Permutation test): ', num2str(proportion_accept_null_permutation)]);

% Calculate confidence intervals
alpha = 0.05; % Significance level for 95% confidence interval
z_score = norminv(1 - alpha / 2); % Z-score for 95% confidence interval

% Calculate confidence intervals for proportions
std_error_t = sqrt((proportion_accept_null_t * (1 - proportion_accept_null_t)) / num_simulations);
conf_interval_t = [proportion_accept_null_t - z_score * std_error_t, proportion_accept_null_t + z_score * std_error_t];

std_error_welch = sqrt((proportion_accept_null_welch * (1 - proportion_accept_null_welch)) / num_simulations);
conf_interval_welch = [proportion_accept_null_welch - z_score * std_error_welch, proportion_accept_null_welch + z_score * std_error_welch];

std_error_permutation = sqrt((proportion_accept_null_permutation * (1 - proportion_accept_null_permutation)) / num_simulations);
conf_interval_permutation = [proportion_accept_null_permutation - z_score * std_error_permutation, proportion_accept_null_permutation + z_score * std_error_permutation];

disp(['95% Confidence Interval (Simple t-test): ', num2str(conf_interval_t)]);
disp(['95% Confidence Interval (Welch''s t-test): ', num2str(conf_interval_welch)]);
disp(['95% Confidence Interval (Permutation test): ', num2str(conf_interval_permutation)]);