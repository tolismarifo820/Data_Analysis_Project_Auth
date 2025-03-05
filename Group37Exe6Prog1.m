% Marifoglou Apostolos 10879
% Isidoros Tsaousis 10042

clear all;
clc;

%code
data = ReadTMSCleaned();

TMS = data(data.TMS == 1, :);
fprintf("## MODELS FITTED INCLUDING SPIKE COLUMN ##\n\n")
% With spike
X = [TMS.Setup, TMS.Stimuli, TMS.Intensity, TMS.Spike, TMS.Frequency, TMS.CoilCode];
Y = TMS.EDduration;

Group37Exe6Fun1(X, Y, "INCLUDING SPIKE");

fprintf("## MODELS FITTED EXCLUDING SPIKE COLUMN ##\n\n")
% Without spike
X = [TMS.Setup, TMS.Stimuli, TMS.Intensity, TMS.Frequency, TMS.CoilCode];
Y = TMS.EDduration;

Group37Exe6Fun1(X, Y, "EXCLUDING SPIKE");

% Comments: 
% All three models perform poorly with the initial data, explaining only a
% small fraction of the variance (adj R^2 < 0.05). Removing the spike column
% allows using ~20% more samples which yields a better fitted model, in terms
% of Adj. R^2. However, MSE increases. Full Linear and Lasso produce
% models with identical coefficients.