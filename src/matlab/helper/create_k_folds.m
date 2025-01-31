function [k_folds, inxs_per_class_per_fold, intervals_per_class_per_fold] = create_k_folds(data, n_folds)
    % recebe:
    % data -> estrutura com o dataset
    % n_folds -> numero de folds que queremos para o dataset (dividir o
    % dataset quantas vezes)
    %
    % retorna:
    % k_folds -> cell array [1, n_folds], com n_folds estruturas com os
    % folds do dataset dado
    % inxs_per_class_per_fold -> cell array [1, n_classes], com vetores
    % begin e final, sendo os indices de inicio e de fim de cada fold para
    % cada classe
    % interval_per_class_per_fold -> cell array [1, n_classes], com o valor
    % de intervalo (floor(array_size / n_folds)) para cada classe
    %
    % estes dois ultimos servem para descargo de consciencia, nao acho que
    % servirao para alguma coisa fora desta funcao
    
    % obter as classes
    classes = unique(data.y, 'sorted');
    n_classes = size(classes, 2);

    % dividir os indices por classe em n_folds grupos
    inxs_per_class_per_fold = cell(1, n_classes);
    intervals_per_class_per_fold = cell(1, n_classes);

    for i = 1 : n_classes
        class_i_data = data.X(:, data.y == classes(1, i));
        n_class_i_data = size(class_i_data, 2);
        interval = floor(n_class_i_data / n_folds); % garantir que e um inteiro e que, ao ser somando n_folds vezes, nao sai para fora dos bounds do array
        intervals_per_class_per_fold{1, i} = interval; % guardar o tamanho do intervalo que foi usado
        inxs = 1 : interval : n_class_i_data;
        % verificar se o array inxs tem n_folds + 1 elementos
        % se nao tiver, acrescentar + 1 elemento (tamanho do class_i_data)
        if size(inxs, 2) == n_folds
            inxs = [inxs, n_class_i_data];
        end
        inxs(1, end) = n_class_i_data + 1; % garantir que o ultimo elemento e o numero de elementos no array + 1
        begin_inxs = inxs(1 : end - 1); % indices onde cada fold comeca
        final_inxs = inxs(2: end) - 1; % indices onde cada fold acaba
        inxs_per_class_per_fold{1, i} = {begin_inxs, final_inxs};
    end

    % construir os folds com os indices calculados previamente
    k_folds = cell(1, n_folds);
    for i = 1 : n_folds
        temp.X = [];
        temp.y = [];
        for e = 1 : n_classes
            begin = inxs_per_class_per_fold{1, e}{1, 1}; % vector of begin inxs for class e
            begin_inx = begin(1, i); % begin inx for fold i
            final = inxs_per_class_per_fold{1, e}{1, 2}; % vector of final inxs for class e
            final_inx = final(1, i); % final inx for fold i
            temp.X = [temp.X, data.X(:, begin_inx : final_inx)];
            temp.y = [temp.y, data.y(:, begin_inx : final_inx)];
        end
        temp.num_data = size(temp.X, 2);
        temp.dim = size(temp.X, 1);
        k_folds{1, i} = temp;
    end

end