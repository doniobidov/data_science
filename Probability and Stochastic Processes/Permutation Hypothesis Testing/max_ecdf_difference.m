function diff_ecdf = max_ecdf_difference(data1, data2)
    % Custom function to calculate maximum absolute difference in ECDFs
    sorted_data = sort([data1; data2]);
    n1 = length(data1);
    n2 = length(data2);

    ecdf1 = zeros(size(sorted_data));
    ecdf2 = zeros(size(sorted_data));

    for i = 1:length(sorted_data)
        ecdf1(i) = sum(data1 <= sorted_data(i)) / n1;
        ecdf2(i) = sum(data2 <= sorted_data(i)) / n2;
    end

    diff_ecdf = max(abs(ecdf1 - ecdf2));
end