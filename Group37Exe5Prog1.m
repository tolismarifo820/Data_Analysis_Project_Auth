% Marifoglou Apostolos 10879
% Isidoros Tsaousis 10042

clear all;
clc;

warning('off', 'all');

% Example data loader
data = ReadTMSCleaned();

data = [data.TMS, data.EDduration, data.Setup];

% clear rows with any NaN values
data = rmmissing(data);

% Make data a table
data = array2table(data, 'VariableNames', {'TMS', 'EDduration', 'Setup'});

% Define training ratio
trainingRatio = 0.8;

% Model degrees to evaluate
degrees = [1, 2, 3, 4];
% TMS values to evaluate
TMSValues = [0, 1];

function [yfit] = getFitPrediction(X_train, Y_train, X_test, degree)
    if degree == 1
        model = fitlm(X_train, Y_train);
        yfit = predict(model, X_test);
    else
        modelname = sprintf('poly%d', degree);
        model = fit(X_train, Y_train, modelname);
        yfit = model(X_test);
    end
end

% Function to evaluate models
function [R2_adj, R2] = evaluateModel(degree, trainingData, testData, useFullData)
    X_train = trainingData.Setup;
    Y_train = trainingData.EDduration;
    X_test = testData.Setup;
    Y_test = testData.EDduration;

    if useFullData
        X_full = [X_train; X_test];
        Y_full = [Y_train; Y_test];

        X_train = X_full;
        Y_train = Y_full;
        X_test = X_full;
        Y_test = Y_full;
    end
    
    p = degree + 1;

    % Get model prediction
    yfit_test = getFitPrediction(X_train, Y_train, X_test, degree);
      
    % Compute R^2 and adjusted R^2 for test data
    [R2_adj, R2] = computeAdjustedRSquared(yfit_test, Y_test, p);
    
    % Display results
end

% Main script
for TMS = TMSValues
    subset = data(data.TMS == TMS, :);    
    % Randomly shuffle data
    shuffledIndices = randperm(size(subset, 1));
    subset = subset(shuffledIndices, :);
    
    % Split data into training and testing
    n = size(subset, 1);
    trainSize = round(n * trainingRatio);
    trainingData = subset(1:trainSize, :);
    testData = subset(trainSize+1:end, :);
    
    for useFullData = [true, false]
        for degree = degrees
            fprintf("TMS %d, degree %d, Test/Train split = %d\n", TMS, degree, useFullData);
            [R2_adj, R2] = evaluateModel(degree, trainingData, testData, useFullData);
            fprintf("R^2 adj: %f (R^2: %f)\n\n", R2_adj, R2);
        end
    end
end

warning('on', 'all');

% Function to compute R^2 and Adjusted R^2 for test data
function [R2_adj, R2] = computeAdjustedRSquared(yfit, Y, p)
    SSR = sum((Y - yfit).^2);      % Sum of squared errors
    SST = sum((Y - mean(Y)).^2);   % Total sum of squares
    n = length(Y);                 % Number of observations

    R2 = 1 - SSR / SST;
    R2_adj = 1 - (1 - R2)*(n - 1) / (n - p - 1);
end

% Comments: We ran tests that show the linear model exhibit a very small
% adj. R2. This indicates a low or none correlation between the data.
% Increasing the degree of the model also increases R2 but this is likely
% an result of overfitting. Spliting the data in train/test subsets results
% in the drastic drop of adj. R2, even to negative values, which supports
% this hypothesis.