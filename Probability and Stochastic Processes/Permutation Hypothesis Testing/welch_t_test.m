function [s1, s2, mu1, mu2, n1, n2, df, t_stat, p_value] = welch_t_test(data1, data2)
    % Calculate statistics for data1
    mu1 = mean(data1);
    s1 = std(data1);
    n1 = length(data1);

    % Calculate statistics for data2
    mu2 = mean(data2);
    s2 = std(data2);
    n2 = length(data2);

    % Calculate Welch's t-statistic
    numer = mu1 - mu2;
    denom = sqrt((s1^2 / n1) + (s2^2 / n2));
    t_stat = numer / denom;

    % Calculate degrees of freedom
    df = ((s1^2 / n1) + (s2^2 / n2))^2 / (((s1^2 / n1)^2) / (n1 - 1) + ((s2^2 / n2)^2) / (n2 - 1));

    % Calculate p-value
    p_value = 2 * tcdf(-abs(t_stat), df); % Two-tailed test
    
    %{
    % Display the statistics
    disp('Statistics for Welch''s t-test:');
    disp(['Sample 1 mean: ', num2str(mu1)]);
    disp(['Sample 1 standard deviation: ', num2str(s1)]);
    disp(['Sample 1 size: ', num2str(n1)]);
    disp(['Sample 2 mean: ', num2str(mu2)]);
    disp(['Sample 2 standard deviation: ', num2str(s2)]);
    disp(['Sample 2 size: ', num2str(n2)]);
    disp(['Degrees of freedom: ', num2str(df)]);
    disp(['T-statistic: ', num2str(t_stat)]);
    disp(['P-value: ', num2str(p_value)]);

    % Plotting the t-distribution with t-statistic
    figure;
    x = linspace(-5, 5, 1000);
    y = pdf('t', x, df); % t-distribution PDF
    plot(x, y, 'LineWidth', 1.5);
    hold on;
    line([t_stat, t_stat], [0, max(y)], 'Color', 'r', 'LineWidth', 1.5); % Vertical line for t-statistic
    title('Welch''s T-Test');
    xlabel('t-values');
    ylabel('Probability Density');
    legend('t-distribution', 'T-statistic');
    grid on;
    hold off;
    %}
    
end