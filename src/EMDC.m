function [class, max_value] = EMDC(data, prototypes, x)
    % euclidean minimum distance classifier
    % returns the class predicted by the classifier and the gk value
    
    classes = unique(data.y, 'sorted'); % obtain the classes present in the dataset
    n_classes = size(classes, 2);
    
    % calculate the gk values
    gk_values = zeros(1, n_classes);
    for i = 1 : n_classes
        gk_values(1, i) = gk_x_euclidean(prototypes(:, i), x);
    end
    
    % return the class that has the maximum gk value.
    [max_value, inx] = max(gk_values);
    class = classes(1, inx);
end