function [ypred, max_values] = MMDC(data_train, data_test)
    % mahalanobis minimum distance classifier.
    % returns the predictions given by the classifier and the max gk value
    % for each sample in x.
    %
    % data_train -> structure with the dataset (only used to get the classes).
    % data_test -> data structure with the samples to be classified.
    
    classes = unique(data_train.y, 'sorted'); % obtain the classes present in the dataset
    n_classes = size(classes, 2);

    % obtain the covariance matrix
    C = calculate_C(data_train);

    % obtain prototypes
    prototypes = calculate_prototypes(data_train);
    
    max_values = zeros(1, data_test.num_data); % save the gk max values for each sample
    ypred = zeros(1, data_test.num_data); % save the predictions for each sample
    
    % predict each sample in the test set
    for e = 1 : data_test.num_data
        [ypred(1, e), max_values(1, e)] = MMDC_inner(C, prototypes, data_test.X(:, e));
    end

    function [class, max_value] = MMDC_inner(C, prototypes, x)
        % calculate the gk values
        gk_values = zeros(1, n_classes);
        for i = 1 : n_classes
            gk_values(1, i) = gk_x_mahalanobis(C, prototypes(:, i), x);
        end
    
        % return the class that has the maximum gk value.
        [max_value, inx] = max(gk_values);
        class = classes(1, inx);
    end

    function [val, k, b] = gk_x_mahalanobis(C, m, x)
        % C -> covariance matrix calculated with calculate_C
        % m -> prototype
        % x -> sample
    
        inv_C = inv(C);
        k = m' * inv_C* x;
        b = 0.5 * m' * inv_C * m;
        val = k - b;
    end

end