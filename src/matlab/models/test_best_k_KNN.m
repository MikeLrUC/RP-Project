function [best_k, mean_errors_per_k, std_errors_per_k] = test_best_k_KNN(data_train, ks, n_folds)
    % data_train: structure with the training dataset.
    % ks: vector with the different k's that we want to test.
    % n_folds: number of folds to use in the kfolds.
    %
    % Uses kfolds (the mean of the results per fold) to assess the
    % performance of the knn classifier for each k that will be tested.
    %
    % returns:
    %   best_k: the value of the best k.
    %   mean_errors_per_k: the mean of the errors per k (mean of n_folds) as
    %   percentages for the training and validation sets.
    %   std_errors_per_k: the stds of the errors per k (std of n_folds) as
    %   percentages for the training and validation sets.

    % create the folds (assim todos os classificadores vao ter as mesmas
    % folds. Tudo bem que nao ha randomness na criacao das folds, mas se,
    % eventualmente for criada, ja fica pronto.)
    k_folds = create_k_folds(data_train, n_folds);    

     % create the data structures to save the errors per fold per k.
    mean_errors_per_k = zeros(2, size(ks, 2)); % means (1, :) for the training and (2, :) for the validation.
    std_errors_per_k = zeros(2, size(ks, 2)); % stds (1, :) for the training and (2, :) for the validation.

    errors_per_fold_training = zeros(1, n_folds); % (training) save the error per fold for a certain k.
    errors_per_fold_validation = zeros(1, n_folds); % (validation) save the error per fold for a certain k.
    
    start_time = cputime;

    for e = 1 : size(ks, 2) % test for each k
        fprintf("k = %d\n", ks(1, e));
        for i = 1 : n_folds % each fold
            
            start_fold_time = cputime;


            fprintf("fold = %d\n", i);
            conc_k_folds = concatenate_k_folds(k_folds, i);
            fprintf("Juntou folds\n");
            % criar modelo
            model = knnrule(conc_k_folds, ks(1, e));
            disp("treinou modelo")
            ypred_train = knnclass(conc_k_folds.X, model); % predictions for the training data (what it already saw)
            disp("classificou training test")
            ypred_validation = knnclass(k_folds{1, i}.X, model); % predictions for the validation data (what it did not see)
            disp("classificou validation test")
            fprintf("calculou modelo e fez previsoes\n");
            
            errors_per_fold_training(1, i) = cerror(ypred_train, conc_k_folds.y);
            errors_per_fold_validation(1, i) = cerror(ypred_validation, k_folds{1, i}.y);

            fprintf("fold_time: %d\n", cputime - start_fold_time);
        end
    
        % calculate the means of the errors and save them
        % training
        mean_errors_per_k(1, e) = mean(errors_per_fold_training) * 100; % save as percentage
        std_errors_per_k(1, e) = std(errors_per_fold_training) * 100; % save as percentage
        % validation
        mean_errors_per_k(2, e) = mean(errors_per_fold_validation) * 100; % save as percentage
        std_errors_per_k(2, e) = std(errors_per_fold_validation) * 100; % save as percentage
    end
    fprintf("time: %d\n", cputime - start_time);


    % find the best k (minor error in the validation set)
    [min_error, inx] = min(mean_errors_per_k(2, :));
    best_k = ks(1, inx);

    % plot the errors per k for training and for validation.
    figure;
    
    subplot(2, 1, 1);
    errorbar(mean_errors_per_k(1, :), std_errors_per_k(1, :), 'linewidth', 2, 'color', '#0076a8'); % training set
    xlabel('k');
    ylabel('error (%)');
    title('Training set.');
    legend('error');

    subplot(2, 1, 2);
    hold on;
    errorbar(mean_errors_per_k(2, :), std_errors_per_k(2, :), 'linewidth', 2, 'color', '#0076a8'); % validation set
    plot(ks, ones(1, size(ks, 2)) * min_error, '--', 'color', '#D95319', 'linewidth', 2);
    xlabel('k');
    ylabel('error (%)');
    title('Validation set.');
    legend('error', 'min error');
    hold off;

end