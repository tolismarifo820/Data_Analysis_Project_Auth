%Empirical Bootstrap Test Function
function [ci, p_value] = Group37Exe3Fun1(data, m0, alpha)
    % Bootstrap hypothesis test for mean
    shifted_data = data - mean(data) + m0;
    boot_means = bootstrp(10000, @mean, shifted_data);
    
    % Confidence interval from original data
    ci = prctile(bootstrp(10000, @mean, data), [alpha/2*100, 100 - alpha/2*100]);
    
    % Compute p-value (two-tailed)
    sample_mean = mean(data);
    p_value = 2 * min(mean(boot_means >= sample_mean), mean(boot_means <= sample_mean));
end

% Comments:The function performs a two-tailed test to assess whether the hypothesized 
% mean is significantly different from the bootstrap distribution of the sample mean. 
% I chose 10000 bootstrap samples in order to be more accurate and persistent.