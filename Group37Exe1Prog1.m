% Marifoglou Apostolos 10879
% Isidoros Tsaousis-Seiras 10042

clear all;
clc;

% Load the data
data = readtable('TMS.xlsx');

% Extract the relevant columns
TMS = data{:, 1};
EDduration = data{:, 2};

% Separate data for with and without TMS
ED_with_TMS = EDduration(TMS == 1);
ED_without_TMS = EDduration(TMS == 0);

% Define common bin edges
num_bins = 32;
[~, edges] = histcounts(EDduration, num_bins);
bin_centers = (edges(1:end-1) + edges(2:end)) / 2;% (I wanted to do it with hist but it is not recommended)

% PDFs for test 
dist_names = {'BirnbaumSaunders', 'Burr', 'Exponential', 'Extreme Value', 'Gamma', 'Generalized Extreme Value', ...
    'Generalized Pareto', 'Half Normal', 'InverseGaussian', 'Logistic', 'Loglogistic', 'Lognormal', ...
    'Nakagami', 'Normal', 'Rayleigh', 'Rician', 'tLocationScale', 'Weibull'};

% Initialize variables to store the best fits
best_x2_with_TMS = inf;
best_x2_without_TMS = inf;

% Loop through each distribution
for i = 1:length(dist_names)
    % Fit distributions 
    dist_with_TMS_temp = fitdist(ED_with_TMS, dist_names{i});
    dist_without_TMS_temp = fitdist(ED_without_TMS, dist_names{i});

    % Perform chi-square goodness-of-fit test
    [h_with_TMS, p_with_TMS, stats_with_TMS] = chi2gof(ED_with_TMS, 'CDF', dist_with_TMS_temp);
    x2_with_TMS = stats_with_TMS.chi2stat;
    % Perform chi-square goodness-of-fit test
    [h_without_TMS, p_without_TMS, stats_without_TMS] = chi2gof(ED_without_TMS, 'CDF', dist_without_TMS_temp);
    x2_without_TMS = stats_without_TMS.chi2stat;

    if x2_with_TMS < best_x2_with_TMS
        best_x2_with_TMS = x2_with_TMS;
        best_fit_with_TMS = dist_names{i};
        best_dist_with_TMS = dist_with_TMS_temp;
    end
    
    if x2_without_TMS < best_x2_without_TMS
        best_x2_without_TMS = x2_without_TMS;
        best_fit_without_TMS = dist_names{i};
        best_dist_without_TMS = dist_without_TMS_temp;
    end
end

% Plot empirical and fitted PDFs
figure;
% Empirical PDFs
counts_with_TMS = histcounts(ED_with_TMS, edges, 'Normalization', 'pdf');
counts_without_TMS = histcounts(ED_without_TMS, edges, 'Normalization', 'pdf');
plot(bin_centers, counts_with_TMS, 'r--', 'LineWidth', 2);
hold on;
plot(bin_centers, counts_without_TMS, 'b--', 'LineWidth', 2);
% Fitted PDFs
x_values = linspace(min(EDduration), max(EDduration), 1000);
plot(x_values, pdf(best_dist_with_TMS, x_values), 'r', 'LineWidth', 2);
plot(x_values, pdf(best_dist_without_TMS, x_values), 'b', 'LineWidth', 2);
hold off;
title('Empirical and Fitted PDFs for ED Duration');
xlabel('ED Duration');
ylabel('Probability Density');
legend('Empirical (with TMS)', 'Empirical (without TMS)', ['Best Fit (with TMS): ' best_fit_with_TMS], ['Best Fit (without TMS): ' best_fit_without_TMS]);

% Print results
fprintf('Best fit for ED with TMS: %s (chi-square = %.4f)\n', best_fit_with_TMS, best_x2_with_TMS);
fprintf('Best fit for ED without TMS: %s (chi-square = %.4f)\n', best_fit_without_TMS, best_x2_without_TMS);

% Comments:The best fitted distributions differ for ED with TMS and for ED
% without TMS.For ED with TMS the best fitted distribution is Burr and for
% ED without TMS the best fitted distribution is Generalized Extreme Value