function [new_data_train, new_data_test, KW_results, chi_sqrt_values] = kruskalwallis_test(data_train, data_test, new_dim, plot, independent_vars_names)
    % data_train: data structure with the train dataset that will be submited to
    % the kruskalwallis test for each feature.
    % data_test: data structure with the test dataset. It is needed so we
    % can create the new structure with the new_dim most discriminant
    % features.
    % plot: flag for the plots, 1 if we want the plots, 0 if not.
    % independent_vars_names: labels for the features.
    
    % Performs feature selection (the selected features remain unchanged).
    % also plots a heatmap with the correlation matrix.
    % returns a data structure with the new_dim most discriminant features
    
    % check if new_dim is valid
    if ~(1 <= new_dim && new_dim <= data_train.dim)
        fprintf("The dimension value given is not valid. It must be less or equal to %d.\nIt defaulted to %d.\n", data_train.dim, data_train.dim);
        new_dim = data_train.dim;
    end
    % for Kruskal Wallis
    KW_results = cell(data_train.dim, 3);
    chi_sqrt_values = zeros(1, data_train.dim);

    for current_feature = 1: data_train.dim
        if plot
            subplot(3, 5, current_feature);
            hold on;
            boxplot(data_train.X(current_feature, :), data_train.y); % boxplot the data
            title(independent_vars_names(1, current_feature));
            hold off;
        end
    
        [KW_results{current_feature, 1}, KW_results{current_feature, 2}, KW_results{current_feature, 3}] = kruskalwallis(data_train.X(current_feature, :), data_train.y, 'off'); % off so it does not display the images
        chi_value = KW_results{current_feature, 2}(2, 5); % it is a cell array, need to store it so i can access the value in the first position
        chi_sqrt_values(1, current_feature) = chi_value{1,1};
    

    end
    
    % print features chi square values
    [~, indexes] = sort(chi_sqrt_values);
    disp('least discriminant.')
    for i = 1 : data_train.dim
        index = indexes(1, i);
        % class_ = independent_vars_names(1, index);
        % fprintf("%f -> %s\n", chi_sqrt_values(1, index), class_{1,1});
        fprintf("%f -> %s\n", chi_sqrt_values(1, index), independent_vars_names{1, index});
    end
    disp('most discriminant.')
    
%     if plot
%         % correlation matrix
%         corr_matrix = corr(data_train.X(:, :)');
%     
%         % heatmap
%         feature_names = independent_vars_names;
%         figure;
%         heatmap(corr_matrix, 'XData', feature_names, 'YData', feature_names);
%     end

    % create the new data structures with the new_dim most discriminant
    % features
    % train
    new_data_train = data_train;
    new_data_train.X = data_train.X(indexes(1, end - new_dim + 1 : end), :); % select the new_dim best features
    new_data_train.dim = new_dim;
    % test
    new_data_test = data_test;
    new_data_test.X = data_test.X(indexes(1, end - new_dim + 1 : end), :); % select the new_dim best features
    new_data_test.dim = new_dim;

end