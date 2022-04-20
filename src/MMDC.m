function [class, max_value] = MMDC(data, C, prototypes, x)
    % mahalanobis minimum distance classifier
    % returns the class predicted by the classifier and the gk value
    %
    % data -> structure with the dataset
    % C -> covariance matrix obtained with calculate_C
    % prototypes -> prototypes for each classe in the dataset
    % x -> sample
    
    classes = unique(data.y, 'sorted'); % obtain the classes present in the dataset
    n_classes = size(classes, 2);
    
    % calculate the gk values
    gk_values = zeros(1, n_classes);
    for i = 1 : n_classes
        gk_values(1, i) = gk_x_mahalanobis(C, prototypes(:, i), x);
    end
    
    % return the class that has the maximum gk value.
    [max_value, inx] = max(gk_values);
    class = classes(1, inx);
end