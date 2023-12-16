function [observed_statistic, p_value] = permutation_test_cdfs(data1, data2, num_permutations)
    % Calculate observed statistic (maximum absolute difference in ECDFs)
    observed_statistic = max_ecdf_difference(data1, data2);

    % Combine the data
    combined_data = [data1; data2];

    % Number of samples in group 1
    n1 = length(data1);

    % Initialize array to store permuted statistics
    permuted_statistics = zeros(num_permutations, 1);

    % Calculate permuted statistics for selected permutations
    for i = 1:num_permutations
        % Shuffle the combined data indices randomly
        shuffled_indices = randperm(length(combined_data));

        % Split the shuffled data into two groups
        permuted_data1 = combined_data(shuffled_indices(1:n1));
        permuted_data2 = combined_data(shuffled_indices(n1 + 1:end));

        % Calculate permuted statistic (maximum absolute difference in ECDFs)
        permuted_statistic = max_ecdf_difference(permuted_data1, permuted_data2);
        permuted_statistics(i) = permuted_statistic;
    end

    % Calculate p-value
    p_value = sum(permuted_statistics >= observed_statistic) / num_permutations;
    
    %{
    % Display results
    disp('Permutation Test Results:');
    disp(['Observed Statistic: ', num2str(observed_statistic)]);
    disp(['P-value: ', num2str(p_value)]);

    % Plot histogram of permuted statistics
    figure;
    h = histogram(permuted_statistics, 'Normalization', 'probability', 'EdgeColor', 'none');
    hold on;
    line([observed_statistic, observed_statistic], [0, max(h.Values)], 'Color', 'r', 'LineWidth', 1.5); % Adjusted line height
    title('Permutation Test: Distribution of Permuted Statistics');
    xlabel('Permuted Statistics');
    ylabel('Probability');
    legend('Permuted Statistics', 'Observed Statistic', 'Location', 'best');
    grid on;

    % Adjust the y-axis limit
    ylim([0, max(h.Values) + max(h.Values) * 0.1]);

    hold off;
    %}
    
end