function [ypred] = BayesianClassifier(data_train, data_test)
    % data_train: structure with the training dataset.
    % data_train: structure with the testing dataset.
    
    % obter as classes
    classes = unique(data_train.y, 'sorted');
    n_classes = size(classes, 2);
    
    % create the structures to save the prior probs and the pdf for each
    % class
    priors = ones(1, n_classes);
    Pdfs = cell(1, n_classes);

    for i = 1 : n_classes
        % criar a estrutura temporaria para obter os Maximal Likelihood
        % estimation of Gaussian mixture models
        inxs = data_train.y == classes(1, i); % obter os indices para a classe i
        aux_data_train.X = data_train.X(:, inxs);
        aux_data_train.y = data_train.y(1, inxs);
        aux_data_train.dim = size(aux_data_train.X, 1);
        aux_data_train.num_data = size(aux_data_train.X, 2);

        % get the pdf for the current class
        Pdfs{1, i} = mlcgmm(aux_data_train);
    
        % calculate the prior for the current class
        priors(1, i) = aux_data_train.num_data / data_train.num_data;

    end

    % create the bayesian model
    model.Pclass = Pdfs;
    model.Prior = priors;

    % Predict the labels for the testing set.
    ypred = bayescls(data_test.X, model) - 1; % retorna as classes a comecar em 1, assim temos de subtrair 1. Como nao usamos .eps no model (Penalty of decision "don't know"), não há problema.

end