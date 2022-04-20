function [prototypes, classes] = calculate_prototypes(data)
    % retorna os prototipos de cada classe e o vetor classes para saber a
    % ordem pela qual os prototipos foram calculados
    classes = unique(data.y, 'sorted');
    n_classes = size(classes, 2);

    % calculate the prototypes for each class
    prototypes = zeros(data.dim, n_classes);

    for i = 1 : n_classes
        class_i_data = data.X(:, data.y == classes(1, i));
        prototypes(:, i) = mean(class_i_data, 2);
    end
end