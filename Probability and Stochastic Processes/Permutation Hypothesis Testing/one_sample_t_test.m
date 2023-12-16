function [s1, mu1, n1, df, t_stat, p_value] = one_sample_t_test(data1, mu_theoretical)
    % Calculate statistics for data1
    mu1 = mean(data1);
    s1 = std(data1);
    n1 = length(data1);

    % Calculate t-statistic
    numer = mu1 - mu_theoretical;
    denom = s1 / sqrt(n1);
    t_stat = numer / denom;

    % Calculate degrees of freedom
    df = n1 - 1;

    % Calculate p-value
    p_value = 2 * tcdf(-abs(t_stat), df); % Two-tailed test
    
    %{
    % Display results
    disp('Simple T-Test Results:');
    disp(['Observed Statistic: ', num2str(t_stat)]);
    disp(['P-value: ', num2str(p_value)]);
    
    % Plot the t-distribution with t-statistic
    figure;
    x = linspace(-5, 5, 1000);
    y = pdf('t', x, df); % t-distribution PDF
    plot(x, y, 'LineWidth', 1.5);
    hold on;
    line([t_stat, t_stat], [0, max(y)], 'Color', 'r', 'LineWidth', 1.5); % Vertical line for t-statistic
    title('Simple T-Test');
    xlabel('t-values');
    ylabel('Probability Density');
    legend('t-distribution', 'T-statistic');
    grid on;
    hold off;
    %}
end