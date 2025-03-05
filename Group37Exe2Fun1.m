% Marifoglou Apostolos 10879
% Isidoros Tsaousis-Seiras 10042

% Function for Parametric Chi-Squared Test
function chi2_stat = Group37Exe2Fun1(sample)
    % Estimate lambda for the exponential distribution
    mu_hat = mean(sample);
    lambda_hat = 1 / mu_hat;
    n = length(sample);
    
    % Perform chi-squared test for the original sample
    [~, edges] = histcounts(sample, 10); % 10 bins
    observed_counts = histcounts(sample, edges);
    
    % Calculate expected counts based on the exponential distribution
    expected_counts = n * (expcdf(edges(2:end), 1 / lambda_hat) - expcdf(edges(1:end-1), 1 / lambda_hat));
    
    chi2_stat = sum((observed_counts - expected_counts).^2 ./ expected_counts);
    
    % Critical value from chi-squared distribution with (bins - 1) degrees of freedom
    crit_value = chi2inv(0.95, 9); % 10 bins -> 9 degrees of freedom
    if chi2_stat > crit_value
        fprintf('Parametric chi-squared test: Stat is greater than critical value (Significant).\n');
    else
        fprintf('Parametric chi-squared test: Stat is less than critical value (Not significant).\n');
    end
end

% Comments:This function performs a parametric chi-squared test to check if the sample follows an exponential distribution.