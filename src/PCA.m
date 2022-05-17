function [new_data_train, new_data_test] = PCA(data_train, data_test, new_dim)
    % data_train: structure with the train dataset to which we want to apply PCA.
    % data_test: structure with the test dataset to which we want to apply PCA.
    % new_dim: the new dimension that we want the dataset to be (must be
    % less or equal to data_train.dim).
    %
    % returns two data structures with the data projected with the model
    % (new_data_train, new_data_test).
    %
    % new_dim can be obtained by using various criterions.
    % - scree plot
    % - kaiser rule
    % - cumulative variance

    % check if the value of new_dim is valid
    if new_dim > data_train.dim
        fprintf("The dimension value given is not valid. It must be less or equal to %d.\nIt defaulted to %d.\n", data_train.dim, data_train.dim);
        new_dim = data_train.dim;
    end

    % obtain the lda model
    model = pca(data_train.X);
    
    % create the data structures with the projected data
    %train
    new_data_train = data_train;
    new_data_train.X = linproj(data_train.X, model);
    new_data_train.dim = new_dim;
    % test
    new_data_test = data_test;
    new_data_test.X = linproj(data_test.X, model);
    new_data_test.dim = new_dim;
end