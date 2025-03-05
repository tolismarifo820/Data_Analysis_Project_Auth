% Marifoglou Apostolos 10879
% Isidoros Tsaousis-Seiras 10042

%code
clear all; clc;

% Load and prepare data
data = ReadTMSCleaned();
TMS = data(data.TMS == 1, :);

% Define training set proportion (e.g., 70% for training)
train_proportion = 0.5;

fprintf("## MODELS FITTED ##\n\n")
% With spike
% X = [TMS.Setup, TMS.Stimuli, TMS.Intensity, TMS.Spike, TMS.Frequency, TMS.CoilCode];
% Y = TMS.EDduration;
% Group37Exe7Fun1(X, Y, train_proportion);

% fprintf("\n## MODELS FITTED EXCLUDING SPIKE COLUMN ##\n\n")
% Without spike
X = [TMS.Setup, TMS.Stimuli, TMS.Intensity, TMS.Frequency, TMS.CoilCode];
Y = TMS.EDduration;
Group37Exe7Fun1(X, Y, train_proportion);

% Comments: Given the results of Ex. 6 we decided to discard the SPIKE
% column. The effectiveness of the models does not increase substantially
% when raising the amount of training data, which indicates that the model
% is not overfitting the data, as it is too simple to do so. 

% The Stepwise model achieves a lower MSE than the other models. This
% stays consistent both when usign the entire dataset and when not.