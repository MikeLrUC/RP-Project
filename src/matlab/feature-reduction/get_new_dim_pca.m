function [new_dim_scree_test, new_dim_kaiser_rule, new_dim_cumulative_variance] = get_new_dim_pca(data_train, cumulative_variance_treshold)
    % data_train: data structure with the dataset that will be used to
    % obtain the eigenvalues.
    % cumulative_variance_treshold: threshold that will be used to decide
    % the new dimension when using the cumulative variance (at least 0.8).
    %
    % returns the three new dimensions, based on the scree plot, kaiser
    % rule and cumulative variance.

    % obtain the model
    model = pca(data_train.X);

    % scree test
    % TODO: Needs to be implemented...

    % kaiser rule
    new_dim_kaiser_rule = sum(model.eigval >= 1);

    % cumulative variance
    cumulative_variances = zeros(1, data_train.dim);
    temp = 0;
    for i = 1 : data_train.dim
        temp = temp + model.eigval(i, 1);
        cumulative_variances(1, i) = temp;
    end
    cumulative_variances = cumulative_variances / sum(model.eigval);

    aux = find(cumulative_variances(1, :) > cumulative_variance_treshold);
    new_dim_cumulative_variance = aux(1, 1);

end