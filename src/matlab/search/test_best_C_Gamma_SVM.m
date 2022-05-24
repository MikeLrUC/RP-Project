function [best_C, best_Gamma] = test_best_C_Gamma_SVM(data_train, Cs, Gammas, n_folds)
    % data_train: structure with the training dataset.
    % Cs: vector with the different C's that we want to test.
    % Gammas: vector with the different Gamma's that we want to test.
    % n_folds: number of folds to use in the kfolds.
    %
    % Uses kfolds (the mean of the results per fold) to assess the
    % performance of the knn classifier for each k that will be tested.
    %
    % returns the best C and best Gamma that it found (the pair that got
    % the minimum error in the validation sets).
    
    t_cpu_start = cputime;

    % Models Evaluation
    n_cs = size(Cs, 2);
    n_gammas = size(Gammas, 2);

    err = zeros(n_folds, n_cs, n_gammas);
    models = cell(n_folds, n_cs, n_gammas);

    k_folds = create_k_folds(data_train, n_folds);
    
    for n = 1 : n_folds
       conc_k_folds = concatenate_k_folds(k_folds, n);
       
       % Parameters Training
       
       for c = 1 : n_cs
           for gamma = 1 : n_gammas
               fprintf('\nFold=%d\nCost=%f\nGamma=%f\n', n, Cs(c), Gammas(gamma));
               % Train SVM
               clear model;
               
               % Create Model
               % t = templateSVM('KernelFunction', 'rbf', 'BoxConstraint', Cs(c), 'KernelScale', sqrt(1 / (2 * Gammas(gamma))), 'Solver', 'SMO', 'Standardize', true);
               t = templateSVM('KernelFunction', 'rbf', 'BoxConstraint', Cs(c), 'KernelScale', sqrt(1 / (2 * Gammas(gamma))), 'Solver', 'SMO');
               model = fitcecoc(conc_k_folds.X', conc_k_folds.y', 'Coding', 'onevsall', 'Learners', t);

               ypred = predict(model, k_folds{1, n}.X');
               err(n, c, gamma) = cerror(ypred, k_folds{1, n}.y) * 100;
               models{n, c, gamma} = model;
           end
       end
       % Plot 2d gamma vs cost w/color
       % Plot 3d gamma vs cost
    end

    % Plotting
    if n_folds > 1 % meio que tem de ser sempre
        merr = squeeze(mean(err));
    end
    
    figure;
    contourf(Gammas, Cs, merr);
    xlabel('Gamma');
    ylabel('Cost');
    % set(gca, 'xtick', g_pot([1:5:numel(g_pot)]))
    % set(gca, 'xticklabel', strcat(strcat('2^{', cellfun(@num2str, num2cell(g_pot([1:5:numel(g_pot)])), 'UniformOutput', 0)), '}'));
    % set(gca, 'ytick', c_pot([1:5:numel(c_pot)]))
    % set(gca, 'yticklabel', strcat(strcat('2^{', cellfun(@num2str, num2cell(c_pot([1:5:numel(c_pot)])), 'UniformOutput', 0)), '}'));
    colorbar
    
    [ix, iy] = find(merr == min(min(merr))); % obter os indices dos que tem o menor erro.
    
    % selecionar apenas um dos que tem o menor erro. Escolhe o que tem
    % maior C e Gamma.
    ix = ix(end);
    iy = iy(end);
    
    hold on;
    fprintf('\nAverage Best Combination C = %d\n and Gamma value = %d\n', Cs(ix), Gammas(iy));
    plot(Gammas(iy), Cs(ix), 'rx', 'markersize', 8, 'linewidth', 1);
    plot(Gammas(iy), Cs(ix), 'mo', 'markersize', 8, 'linewidth', 1);
    hold off;

    % save the best parameters to return them
    best_C = Cs(ix);
    best_Gamma = Gammas(iy);
    
    % ix_min_err = find(err(:, ix, iy) == min(err(:, ix, iy))); % encontrar o modelo que obteve o menor erro.
    % ix_min_err = ix_min_err(end); % para o caso de haver mais do que um, escolhemos o ultimo.
    % best = models{ix_min_err, ix, iy}; % selecionar o melhor modelo.
    % [ypred, dfce] = predict(best, tst.X'); % nao se aplica


    [X, Y] = meshgrid(Gammas, Cs); % mesh grid for 3d surface graph (Error, C, Gamma)
    
    figure; surf(X, Y, merr)
    xlabel('Gamma');
    ylabel('Cost');
    zlabel('Error')
    % set(gca, 'xtick', g_pot([1:5:numel(g_pot)]))
    % set(gca, 'xticklabel', strcat(strcat('2^{', cellfun(@num2str, num2cell(g_pot([1:5:numel(g_pot)])), 'UniformOutput', 0)), '}'));
    % set(gca, 'ytick', c_pot([1:5:numel(c_pot)]))
    % set(gca, 'yticklabel', strcat(strcat('2^{', cellfun(@num2str, num2cell(c_pot([1:5:numel(c_pot)])), 'UniformOutput', 0)), '}'));
    colorbar
    
    t_cpu_end = cputime;
    fprintf('\nCPUtime %4.2f\n', t_cpu_end - t_cpu_start);

end