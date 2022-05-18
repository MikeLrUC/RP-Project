function [model] = FLDA(data, prototypes, new_dim)
    % I THINK THIS DOES NOT WORK, DO NOT USE IT.
    % Use the one from the stprtool.

    % https://sthalles.github.io/fisher-linear-discriminant/

    % data -> structure with the dataset
    % prototypes -> prototypes for each classe in the dataset
    % new_dim -> the new dimension that we want the dataset to have (it has
    % to be between 1 and c-1, with c being the number of classes in the
    % dataset)
    
    % obter as classes
    classes = unique(data.y, 'sorted');
    n_classes = size(classes, 2);

    % calcular Sw e Sb
    Sw = zeros(data.dim, data.dim); % create Sw matrix
    Sk_matrices = cell(1, n_classes); % save Sk matrices
    Sb = zeros(data.dim, data.dim);
    m = mean(data.X, 2); % global mean
    Sb_k_matrices = cell(1, n_classes); % save Sb_k matrices

    for i = 1 : n_classes
        class_i_data = data.X(:, data.y == classes(1, i));
        Sk_matrices{1, i} = calculate_Sk(class_i_data, prototypes(:, i));
        Sb_k_matrices{1, i} = calculate_Sb_k(prototypes(:, i), m, size(class_i_data, 2));
        Sw = Sw + Sk_matrices{1, i};
        Sb = Sb + Sb_k_matrices{1, i};
    end

    % calcular eigenvalues e eigenvectors
    matrix = inv(Sw) * Sb;
    [V, D] = eig(matrix);

    % retornar os dim maiores eigenvectors
    [new_D, inxs] = sort(diag(D), 1, 'descend');
    
    W = zeros(data.dim, new_dim);
    for i = 1 : new_dim
        W(:, i) = V(:, inxs(1, i));
    end

    model.W = W;
    model.eigval = new_D;
    model.Sw = Sw;
    model.Sb = Sb;
    model.mean_x = m;
    model.fun = 'linproj';
    % model.Sk_matrices = Sk_matrices;
    % model.Sb_k_matrices = Sb_k_matrices;
    
    if n_classes == 2
        model.b = -(W' * prototypes(:, 1) + W' * prototypes(:, 2)) / 2;
    end

    function [Sk] = calculate_Sk(xk, mk)
        aux = (xk - mk); % calculated only once.
        Sk = aux * aux';
    end

    function [Sb_k] = calculate_Sb_k(mk, m, n_samples_class_k)
        aux = (mk - m); % calculated only once.
        Sb_k = n_samples_class_k * aux * aux';
    end

end