% Marifoglou Apostolos 10879
% Isidoros Tsaousis-Seiras 10042

function [y_fit_full, y_fit_stepwise, y_fit_lasso] = Group37Exe6Fun1(X, Y, str_injected)
    
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

    y_fit_full = predict(full_lm, X);
    
    % For stepwise model
    stepwise_mse = stepwise_lm.MSE;
    stepwise_adjR2 = stepwise_lm.Rsquared.Adjusted;

    y_fit_stepwise = predict(stepwise_lm, X);
    
    % For Lasso model we need to manually calculate the metrics
    [~, min_idx] = min(lasso_fit_info.MSE);
    
    lasso_best_coeffs = lasso_lm(:, min_idx);
    lasso_best_intercept = lasso_fit_info.Intercept(min_idx);
    lasso_y_pred = lasso_best_intercept + X * lasso_best_coeffs;

    y_fit_lasso = lasso_y_pred;
    
    lasso_mse = mean((Y - lasso_y_pred).^2);
    
    % Coeff of determination
    original_SSTot  = sum((Y - mean(Y)).^2);
    lasso_SSRes = sum((Y - lasso_y_pred).^2);
    lasso_R2 = 1 - lasso_SSRes/original_SSTot;
    
    n = length(Y);
    p = sum(lasso_best_coeffs ~= 0);
    lasso_adjR2 = 1 - (1 - lasso_R2)*(n-1)/(n - p - 1);

    fprintf("Number of usable samples: %d\n", n)
      
    % Create comparison table
    modelNames = {'Full Linear Model', 'Stepwise Model', 'Lasso Model'};
    MSE_values = [full_mse, stepwise_mse, lasso_mse];
    adjR2_values = [full_adjR2, stepwise_adjR2, lasso_adjR2];
    R2_values = [full_lm.Rsquared.Ordinary, stepwise_lm.Rsquared.Ordinary, lasso_R2];
    
    comparison = table(MSE_values', adjR2_values', R2_values', ...
        'RowNames', modelNames, ...
        'VariableNames', {'MSE', 'Adjusted_R2', 'R2'});
    
    disp(comparison)
    fprintf('\n')

    figure
    plot(Y, 'b')
    hold on
    plot(y_fit_full, 'r--')
    plot(y_fit_stepwise, 'g--')
    plot(y_fit_lasso, 'm--')
    legend('Original Data', 'Full Linear Model', 'Stepwise Model', 'Lasso Model')
    title('Models comparison, ' + str_injected)
    xlabel('Index')
    ylabel('Y')
    hold off
end