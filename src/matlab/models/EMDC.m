function [ypred, max_values] = EMDC(data_train, prototypes, data_test)
    % euclidean minimum distance classifier.
    % returns the predictions given by the classifier and the gk values for
    % each sample in the data_test.
    %
    % data_train -> structure with the dataset (only used to get the classes).
    % prototypes -> prototypes for each classe in the dataset.
    % data_test -> data structure with the samples to be classified.
    
    classes = unique(data_train.y, 'sorted'); % obtain the classes present in the dataset.
    n_classes = size(classes, 2);
        
    max_values = zeros(1, data_test.num_data); % save the gk max values for each sample.
    ypred = zeros(1, data_test.num_data); % save the predictions for each sample.   
   
    % predict each sample in the test set
    for e = 1 : data_test.num_data
        [ypred(1, e), max_values(1, e)] = EMDC_inner(prototypes, data_test.X(:, e));
    end

    function [class, max_value] = EMDC_inner(prototypes, x)
        % calculate the gk values
        gk_values = zeros(1, n_classes);
        for i = 1 : n_classes
            gk_values(1, i) = gk_x_euclidean(prototypes(:, i), x);
        end
    
        % return the class that has the maximum gk value.
        [max_value, inx] = max(gk_values);
        class = classes(1, inx);
    end

end