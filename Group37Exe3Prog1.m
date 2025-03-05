% Marifoglou Apostolos 10879
% Isidoros Tsaousis-Seiras 10042

clear all;
clc;

% Load data
data = readtable('TMS.xlsx');

% Extract relevant columns
TMS = data{:, 1};
EDduration = data{:, 2};
Setup = data{:, 5};

% Separate data into groups
ED_without_TMS = EDduration(TMS == 0);
Setup_without_TMS = Setup(TMS == 0);

ED_with_TMS = EDduration(TMS == 1);
Setup_with_TMS = Setup(TMS == 1);

% Calculate overall means
m0 = mean(ED_without_TMS);
m1 = mean(ED_with_TMS);

% Initialize results tables
num_setups = 6;
alpha = 0.05;

results_without_TMS = table('Size', [num_setups, 6], ...
    'VariableTypes', {'double', 'double', 'double', 'double', 'double', 'string'}, ...
    'VariableNames', {'Setup', 'Mean', 'Lower_CI', 'Upper_CI', 'P_Value', 'Hypothesis_Result'});

results_with_TMS = table('Size', [num_setups, 6], ...
    'VariableTypes', {'double', 'double', 'double', 'double', 'double', 'string'}, ...
    'VariableNames', {'Setup', 'Mean', 'Lower_CI', 'Upper_CI', 'P_Value', 'Hypothesis_Result'});

% Analyze each setup without TMS
for i = 1:num_setups
    current_data = ED_without_TMS(Setup_without_TMS == i);
    results_without_TMS{i, 'Setup'} = i;
    results_without_TMS{i, 'Mean'} = mean(current_data);
    
    % Check normality using chi-squared test
    [h, ~] = chi2gof(current_data, 'Alpha', alpha);
    
    if h == 0 % Data is normal, use t-test
        [~, p_value, ci] = ttest(current_data, m0); % Directly get CI from ttest
    else % Data not normal, use bootstrap
        [ci, p_value] = Group37Exe3Fun1(current_data, m0, alpha);
    end
    
    results_without_TMS{i, 'Lower_CI'} = ci(1);
    results_without_TMS{i, 'Upper_CI'} = ci(2);
    results_without_TMS{i, 'P_Value'} = p_value;
    
    % Determine hypothesis result
    if p_value >= alpha
        results_without_TMS{i, 'Hypothesis_Result'} = "Fail to reject H0: Mean is equal to " + num2str(m0);
    else
        results_without_TMS{i, 'Hypothesis_Result'} = "Reject H0: Mean isn't equal to " + num2str(m0);
    end
end

% Analyze each setup with TMS
for i = 1:num_setups
    current_data = ED_with_TMS(Setup_with_TMS == i);
    results_with_TMS{i, 'Setup'} = i;
    results_with_TMS{i, 'Mean'} = mean(current_data);
    
    % Check normality using chi-squared test
    [h, ~] = chi2gof(current_data, 'Alpha', alpha);
    
    if h == 0 % Data is normal, use t-test
        [~, p_value, ci] = ttest(current_data, m1); % Directly get CI from ttest
    else % Data not normal, use bootstrap
        [ci, p_value] = Group37Exe3Fun1(current_data, m1, alpha);
    end
    
    results_with_TMS{i, 'Lower_CI'} = ci(1);
    results_with_TMS{i, 'Upper_CI'} = ci(2);
    results_with_TMS{i, 'P_Value'} = p_value;
    
    % Determine hypothesis result
    if p_value >= alpha
        results_with_TMS{i, 'Hypothesis_Result'} = "Fail to reject H0: Mean is equal to " + num2str(m1);
    else
        results_with_TMS{i, 'Hypothesis_Result'} = "Reject H0: Mean isn't equal to " + num2str(m1);
    end
end

% Display results
fprintf("Overall mean ED duration without TMS: m0 = %.3f\n", m0);
fprintf("Overall mean ED duration with TMS: m1 = %.3f\n\n", m1);

disp('Results for ED duration WITHOUT TMS:');
disp(results_without_TMS);

disp('Results for ED duration WITH TMS:');
disp(results_with_TMS);

% Comments: Without TMS: Setups 3,4,5 show statistically significant deviations from the overall mean (13.257), 
% suggesting these configurations impact ED duration. Setup 6 has an unusually wide CI (-2.88 to 114.38).
% It is created because we have limited data points and high variability. With TMS: Setups 2,4,6 deviate 
% significantly from the overall mean (12.195). Notably, Setup 6 (CI: 20.02-62.15) shows a large effect 
% size despite wide confidence bounds. Setups 3 and 5 (p ≈ 0.07) approach significance.
% Conclusion: TMS appears to influence ED duration differently across setups, with configurations 2,4,6 showing 
% significant effects. Further data collection for setups with wide CIs (e.g., Setup 6) would strengthen conclusions.