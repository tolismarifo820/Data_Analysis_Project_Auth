% Marifoglou Apostolos 10879
% Isidoros Tsaousis 10042

clear all;
clc;

%code
data = ReadTMSCleaned();

TMS = data(data.TMS == 1, :);
% Spike will not be included 

fprintf("## MODELS FITTED EXCLUDING preTMS ##\n\n")
X = [TMS.Setup, TMS.Stimuli, TMS.Intensity, TMS.Frequency, TMS.CoilCode];
Y = TMS.EDduration;

Group37Exe8Fun1(X, Y, 95);

% Intuitively, we expect the inclusion of
% the preTMS time to be of significant help, because it a somewhat tight
% lower bound to the EDduration.
fprintf("## MODELS FITTED INCLUDING preTMS ##\n\n")

X = [TMS.Setup, TMS.preTMS, TMS.Stimuli, TMS.Intensity, TMS.Frequency, TMS.CoilCode];
Y = TMS.EDduration;

Group37Exe8Fun1(X, Y, 95);

fprintf("## MODELS FITTED INCLUDING preTMS AND postTMS ##\n\n")
% Including postTMS means we can have a perfect formula for EDduration.
X = [TMS.preTMS, TMS.postTMS, TMS.Stimuli, TMS.Intensity, TMS.Frequency, TMS.CoilCode];
Y = TMS.EDduration;
Group37Exe8Fun1(X, Y, 95);

% Comments: 
% The inclusion of preTMS allows much better fitting of the data. There is
% a relation between preTMS and EDduration, as preTMS is a lower bound for
% the EDduration. The PCR model fails to perform as well as the other
% models.