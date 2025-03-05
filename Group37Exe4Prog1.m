% Marifoglou Apostolos 10879
% Isidoros Tsaousis-Seiras 10042

clear all;
clc;

% Load the data from TMS.xlsx
data = readtable('TMS.xlsx');

% Filter the data for TMS = 1
TMS = data(data.TMS == 1, :);

% Get unique Setup values
uniqueSetups = unique(TMS.Setup);

% Initialize a results table
results = table('Size', [0, 5], 'VariableTypes', {'double', 'double', 'double', 'logical', 'logical'}, ...
                'VariableNames', {'Setup', 'PearsonR', 'PValue', 'RandomReject', 'ParametricReject'});

% Set parameters
alpha = 0.05;
numRandomizations = 1000;

% Set random seed for reproducibility (this is not necessary)
rng(0);

% Loop through each setup
for i = 1:length(uniqueSetups)
    setup = uniqueSetups(i);
    setupData = TMS(TMS.Setup == setup, :);
    preTMS = setupData.preTMS;
    postTMS = setupData.postTMS;
     
    n = length(preTMS);
    
    % Perform Pearson correlation
    [r, p] = corr(preTMS, postTMS, 'Type', 'Pearson');
    parametricReject = p < alpha;
    
    % Perform randomization test
    originalR = r;
    randomizedRs = zeros(numRandomizations, 1);
    for j = 1:numRandomizations
        idx = randperm(n);
        randomizedPostTMS = postTMS(idx);
        randomizedRs(j) = corr(preTMS, randomizedPostTMS, 'Type', 'Pearson');
    end
    
    % Determine rejection based on quantiles
    lowerQuantile = quantile(randomizedRs, alpha / 2);
    upperQuantile = quantile(randomizedRs, 1 - alpha / 2);
    randomReject = (originalR < lowerQuantile) || (originalR > upperQuantile);
    
    % Store results
    results = [results; {setup, originalR, p, randomReject, parametricReject}];
end

% Display results
disp(results);

% Comments:The results indicate that none of the setups show a statistically significant linear correlation between preTMS and
% postTMS at the 5% significance level. Both the parametric (p-values > 0.05*) and randomization tests (observed correlations
% within the 95% quantile range of randomized correlations) consistently fail to reject the null hypothesis of no correlation. 
% The Pearson correlation coefficients (e.g., 0.45 for Setup 1, -0.17 for Setup 2) are small in magnitude, suggesting weak linear 
% relationships across all setups. This implies that the timing of TMS administration (preTMS) does not linearly predict the 
% remaining duration of ED (postTMS) in any of the measurement configurations.