function [ypred] = MulticlassFLD(data_train, data_test)
    % data_train: structure with the training dataset.
    % data_test: structure with the testing dataset.
    
    % this function uses a strategy of one against all in order to classify
    % samples in problems with more than 2 classes.

    % verificar o numero de classes
    classes = unique(data_train.y, 'sorted'); % obtain the classes present in the dataset.
    n_classes = size(classes, 2);

    % criar as estruturas para guardar as predictions de cada
    % classificador.
    % Teremos tantos classificadores quanto classes.
    ypred_per_classifier = cell(n_classes, 1); % per line

    % obter as previsoes de cada classificador
    for i = 1 : n_classes
        % dividir o training dataset em duas classes (binario)
        aux_data_train = data_train;
        aux_data_train.y = (aux_data_train.y == classes(1, i)) + 1; % 2 signidica que e positivo, 1 negativo.

        % utilizar o fld para duas classes
        model = fld(aux_data_train);
        
        % obter previsões para o problema binario
        ypred_per_classifier{i, 1} = linclass(data_test.X, model) - 1; % the predictions returned by the linclass functions can be 1 or 2. So we subtract 1 in order to have the predictions being 0 or 1.
    
    end

    % juntar as previsoes de cada classificador. Se houverem multiplos
    % classificadores que tenham dado positivo para determinada sample, a
    % classe atribuida sera a do classificador que foi corrido em primeiro.
    
    % create a matrix with the predictions from every classifier. Each row
    % has the predictions of a classifier.
    predictions = cell2mat(ypred_per_classifier);

    [~, ypred] = max(predictions);
    ypred = ypred - 1;

    % como as classes foram testadas por ordem (0, 1, 2, etc.), os indices
    % onde foi encontrado o maximo para a sample i vai pertencer a (1, 2,
    % 3, etc.), correspondendo o 1 a classe que foi testada primeiro, logo
    % a 0. Assim sendo, podemos subtrair 1 aos indices para obter a classe
    % que foi prevista pelo classificador.

end