% Marifoglou Apostolos 10879
% Isidoros Tsaousis 10042

function [] = Group37Exe7Fun1(X, Y, train_ratio)

    idx = all(~isnan(X), 2) & ~isnan(Y);
    X = X(idx, :);
    Y = Y(idx);

    n = length(Y);
    assert(size(X,1) == n, 'Error: len(X) != len(Y)');
    
    n_train = floor(train_ratio * n);
    rand_idx = randperm(n);
    train_idx = rand_idx(1:n_train);
    test_idx = rand_idx(n_train+1:end);

    X_train = X(train_idx, :);
    Y_train = Y(train_idx);
    X_test = X(test_idx, :);
    Y_test = Y(test_idx);

    %%% Stepwise

    % Do feature selection using stepwiselm on the entirety of the data.
    stepwise_lm = stepwiselm(X, Y, 'Verbose', 0);

    % get the selected features
    selected_features = stepwise_lm.PredictorNames;
    % They are strings. We need to convert them to indices.
    selected_feature_indices = zeros(1, length(selected_features));
    for i = 1:length(selected_features)
        selected_feature_indices(i) = find(strcmp(selected_features{i}, stepwise_lm.VariableNames));
    end

    % Now we can train the model using only the selected features.
    X_train_stepwise = X_train(:, selected_feature_indices);
    X_test_stepwise = X_test(:, selected_feature_indices);

    stepwise_lm = stepwiselm(X_train_stepwise, Y_train, 'Verbose', 0);

    %%% Lasso
    [lasso_lm_temp, lasso_fit_info_temp] = lasso(X, Y);

    [~, min_idx] = min(lasso_fit_info_temp.MSE);
    
    % Select the non-zero coefficients
    lasso_kept_coeff_idx = find(lasso_lm_temp(:, min_idx) ~= 0);

    X_train_lasso = X_train(:, lasso_kept_coeff_idx);
    X_test_lasso = X_test(:, lasso_kept_coeff_idx);

    [lasso_lm, lasso_fit_info] = lasso(X_train_lasso, Y_train);

    % Predict the data using the stepwise model.
    Y_pred_stepwise = predict(stepwise_lm, X_test_stepwise);
    lasso_y_pred = lasso_lm(:, min_idx)' * X_test_lasso' + lasso_fit_info.Intercept(min_idx);

    %%% Linear
    warning('off', 'all');
    linear_lm = fitlm(X_train, Y_train);
    warning('on', 'all');

    linear_y_pred = predict(linear_lm, X_test);

    % Calculate the MSE for each model
    stepwise_mse_1 = mean((Y_test - Y_pred_stepwise).^2);
    lasso_mse_1 = mean((Y_test - lasso_y_pred').^2);
    linear_mse_1 = mean((Y_test - linear_y_pred).^2);

    % Fit the models on the full dataset, but test them on the same test subset
    stepwise_lm_full = stepwiselm(X, Y, 'Verbose', 0);
        warning('off', 'all');
    linear_lm_full = fitlm(X, Y);
    warning('on', 'all');

    [lasso_lm_full, lasso_fit_info_full] = lasso(X, Y);

    % Predict the data using the full models and the same test subset
    % Despite the models having reduced dimentions, we use the X_test that has all the features
    % because the models were trained on the full dataset, and they expect the full dataset.

    stepwise_full_y_pred = predict(stepwise_lm_full, X_test);

    [~, lasso_full_min_idx] = min(lasso_fit_info_full.MSE);
    lasso_y_pred_full = lasso_lm_full(:, lasso_full_min_idx)' * X_test' + lasso_fit_info_full.Intercept(lasso_full_min_idx);

    linear_y_pred_full = predict(linear_lm_full, X_test);

    % Calculate the MSE for each model
    stepwise_mse_2 = mean((Y_test - stepwise_full_y_pred).^2);
    lasso_mse_2 = mean((Y_test - lasso_y_pred_full').^2);
    linear_mse_2 = mean((Y_test - linear_y_pred_full).^2);

    % Create a table for the results
    results = table({'Stepwise'; 'Lasso'; 'Linear'}, ...
                    [stepwise_mse_1; lasso_mse_1; linear_mse_1], ...
                    [stepwise_mse_2; lasso_mse_2; linear_mse_2], ...
                    [stepwise_mse_1/stepwise_mse_2; lasso_mse_1/lasso_mse_2; linear_mse_1/linear_mse_2], ...
                    'VariableNames', {'Model', sprintf('MSE (train data %0.0f percent)', train_ratio*100), 'MSE (Full data)', 'MSE Ratio'});

    % Display the table
    disp(results);
end