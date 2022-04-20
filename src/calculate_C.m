function [C, cov_matrices] = calculate_C(data)
    % slide 9, RP22_Chap3_LinDiscriminants_Part1-slides.pdf

    classes = unique(data.y, 'sorted');
    n_classes = size(classes, 2);

    cov_matrices = cell(1, n_classes);
    C = zeros(data.dim, data.dim);

    for i = 1 : n_classes
        class_i_data = data.X(:, data.y == classes(1, i))'; % transposed because cov() assumes that the samples are in the rows and the features on the columns
        cov_matrices{1, i} = cov(class_i_data);
        C = C + cov_matrices{1, i};
    end
end