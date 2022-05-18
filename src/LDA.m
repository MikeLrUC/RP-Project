function [new_data_train, new_data_test] = LDA(data_train, data_test, new_dim)
    % data_train: structure with the train dataset to which we want to apply LDA.
    % data_test: structure with the test dataset to which we want to apply LDA.
    % new_dim: the new dimension that we want the dataset to be (must be
    % between c - 1 and k, with k being the number of features and c being
    % the number of classes.
    %
    % returns two data structures with the data projected with the model
    % (new_data_train, new_data_test).


    % check if the value of new_dim is valid
    classes = unique(data.y, 'sorted');
    n_classes = size(classes, 2);

    temp = min(n_classes - 1, data_train.dim);
    if new_dim > temp
        fprintf("The dimension value given is not valid. It must be less or equal to %d.\nIt defaulted to %d.\n", temp, temp);
        new_dim = temp;
    end

    % obtain the lda model
    model = lda(data_train, new_dim);
    model.eigval = real(diag(model.eigval)); % the eigen values are complex

    % create the data structures with the projected data
    % train
    new_data_train = data_train;
    new_data_train.X = linproj(data_train.X, model);
    new_data_train.dim = new_dim;
    % test
    new_data_test = data_test;
    new_data_test.X = linproj(data_test.X, model);
    new_data_test.dim = new_dim;
end