% Marifoglou Apostolos 10879
% Isidoros Tsaousis-Seiras 10042

function [] = Group37Exe8Fun1(X, Y, explained_variance)
    
    idx = all(~isnan(X), 2) & ~isnan(Y);
    X = X(idx, :);
    Y = Y(idx);
    
    warning('off', 'all');
    full_lm = fitlm(X, Y);
    warning('on', 'all');
    stepwise_lm = stepwiselm(X, Y, 'Verbose', 0);
 
    % Lasso is a linear model, just not based on MSE alone
    [lasso_lm, lasso_fit_info] = lasso(X, Y);
    
    % Get the MSE and adjusted RSquared of each method and compare them.
    % For full linear model
    full_mse = full_lm.MSE;
    full_adjR2 = full_lm.Rsquared.Adjusted;
    
    % For stepwise model
    stepwise_mse = stepwise_lm.MSE;
    stepwise_adjR2 = stepwise_lm.Rsquared.Adjusted;
    
    % For Lasso model we need to manually calculate the metrics
    [~, min_idx] = min(lasso_fit_info.MSE);
    
    lasso_best_coeffs = lasso_lm(:, min_idx);
    lasso_best_intercept = lasso_fit_info.Intercept(min_idx);
    lasso_y_pred = lasso_best_intercept + X * lasso_best_coeffs;
    
    lasso_mse = mean((Y - lasso_y_pred).^2);
    
    original_SSTot  = sum((Y - mean(Y)).^2);
    lasso_SSRes = sum((Y - lasso_y_pred).^2);
    lasso_R2 = 1 - lasso_SSRes/original_SSTot;
    
    n = length(Y);
    p = sum(lasso_best_coeffs ~= 0);
    lasso_adjR2 = 1 - (1 - lasso_R2)*(n-1)/(n - p - 1);

    % PCR model
    warning('off', 'all');
    [~, score, ~, ~, explained] = pca(X);
    warning('on', 'all');

    % Find the number of components that explain the desired variance
    % (Stackoverflow code snippet)
    n_components = find(cumsum(explained) >= explained_variance, 1);

    % Create the new X matrix using only the kept components
    X_pcr = score(:, 1:n_components);

    % Train the model using those components
    pcr_lm = fitlm(X_pcr, Y);

    % Calculate the MSE
    
    pcr_mse = pcr_lm.MSE;
    pcr_adjR2 = pcr_lm.Rsquared.Adjusted;

    fprintf("Number of usable samples: %d\n", n)
    % Create comparison table
    modelNames = {'Full Linear Model', 'Stepwise Model', 'Lasso Model', 'PCR Model'};
    MSE_values = [full_mse, stepwise_mse, lasso_mse, pcr_mse];
    adjR2_values = [full_adjR2, stepwise_adjR2, lasso_adjR2, pcr_adjR2];
    
    comparison = table(MSE_values', adjR2_values', ...
        'RowNames', modelNames, ...
        'VariableNames', {'MSE', 'Adjusted_R2'});
    
    disp(comparison)
    fprintf('\n')
end