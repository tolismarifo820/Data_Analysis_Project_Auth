% Marifoglou Apostolos 10879
% Isidoros Tsaousis-Seiras 10042

% Function for Exponential Fit Test using chi2gof and Resampling
function [p_value, chi2_stat, chi2_random] = Group37Exe2Fun2(sample)
    % Estimate rate parameter for exponential distribution
    mu_hat = mean(sample);
    lambda_hat = 1 / mu_hat;
    
    % Generate random samples for resampling test
    num_samples = 1000;
    n = length(sample);
    random_samples = exprnd(mu_hat, n, num_samples);
    
    % Initialize chi-squared statistics
    chi2_random = zeros(num_samples, 1);

    % Perform chi-squared goodness-of-fit test for random samples
    for i = 1:num_samples
        [~, ~, stats] = chi2gof(random_samples(:, i), 'CDF', @(x) expcdf(x, 1 / lambda_hat));
        chi2_random(i) = stats.chi2stat;
    end

    % Chi-squared test for the original sample
    [~, p_value, stats] = chi2gof(sample, 'CDF', @(x) expcdf(x, 1 / lambda_hat));
    chi2_stat = stats.chi2stat;
end

% Comments:This function tests if the sample follows an exponential distribution using chi2gof and resampling.