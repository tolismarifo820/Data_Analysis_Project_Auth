% Marifoglou Apostolos 10879
% Isidoros Tsaousis-Seiras 10042

clear all;
clc;

% Load the data
data = readtable('TMS.xlsx');

% Extract relevant columns
TMS = data{:, 1};
EDduration = data{:, 2};
CoilCode = str2double(data.CoilCode);

% Separate data for with and without TMS
ED_with_TMS = EDduration(TMS == 1);
Coil_eight = ED_with_TMS(CoilCode == 1);
Coil_round = ED_with_TMS(CoilCode == 0);

% Perform exponential fit and chi-squared test for each group
[p_eight, chi2_eight, chi2_random_eight] = Group37Exe2Fun2(Coil_eight);
[p_round, chi2_round, chi2_random_round] = Group37Exe2Fun2(Coil_round);

% Evaluate if the chi-squared statistic is in the right tail
is_in_tail_eight = chi2_eight > prctile(chi2_random_eight, 95);
is_in_tail_round = chi2_round > prctile(chi2_random_round, 95);

% Perform parametric chi-squared test for comparison
disp('Coil Eight:');
parametric_test_eight = Group37Exe2Fun1(Coil_eight);
disp('Coil Round:');
parametric_test_round = Group37Exe2Fun1(Coil_round);

% Display results
fprintf('Exponential fit test results for Coil Eight:\n');
fprintf('Chi-squared statistic (Resampling): %.2f\n', chi2_eight);
fprintf('p-value (Resampling): %.4f\n', p_eight);
fprintf('Is in right tail (Resampling): %d\n', is_in_tail_eight);
fprintf('Parametric chi-squared test: %.2f\n', parametric_test_eight);

fprintf('\nExponential fit test results for Coil Round:\n');
fprintf('Chi-squared statistic (Resampling): %.2f\n', chi2_round);
fprintf('p-value (Resampling): %.4f\n', p_round);
fprintf('Is in right tail (Resampling): %d\n', is_in_tail_round);
fprintf('Parametric chi-squared test: %.2f\n', parametric_test_round);
crit_value = chi2inv(0.95, 9);
fprintf('Critical value %.4f \n',crit_value);

% Comments: For Coil Eight(100 samples), the two methods disagree.The p-value (0.2650) is greater
% than the significance level (0.05), so we fail to reject the null hypothesis.
% The data may follow the exponential distribution.The parametric chi-squared 
% statistic (40.77) is greater than the critical value (16.92),suggesting that the
% data does not follow the exponential distribution. So the parametric test suggesting
% a poor fit and the resampling method suggesting a good fit. The resampling results 
% are generally considered more robust, especially when sample sizes are small or data
% deviates from assumptions of the parametric test(parametric test is more sensitive 
% to deviations from the expected distribution when the sample size is small or the 
% data does not meet the assumptions of the test).
% may not be reliable due to low expected counts in some bins. 

% For Coil Round, the two methods agree. The p-value (0.1310) is greater than the 
% significance level (0.05), so we fail to reject the null hypothesis. 
% The data may follow the exponential distribution.The parametric chi-squared 
% statistic (12.13) is less than the critical value (16.92), which also supports 
% the conclusion that the data may follow the exponential distribution. Lastly it
% is important to note that the sample size is small (19 samples) so the results are less reliable
% but the agreement between the two methods increases confidence in the conclusion.