function [conc_k_folds] = concatenate_k_folds(k_folds, index)
    % index -> index of the kfold that is not supposed to be concatenated with
    % the rest
    % k_folds -> cell array with data structures wit the data of each fold

    n_folds = size(k_folds, 2);

    conc_k_folds.X = [];
    conc_k_folds.y = [];
    for i = 1 : n_folds
        if i ~= index
            conc_k_folds.X = [conc_k_folds.X, k_folds{1, i}.X];
            conc_k_folds.y = [conc_k_folds.y, k_folds{1, i}.y];
        end
    end
    conc_k_folds.dim = size(conc_k_folds.X, 1);
    conc_k_folds.num_data = size(conc_k_folds.X, 2);
end