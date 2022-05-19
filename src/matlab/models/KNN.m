function [ypred] = KNN(data_train, data_test, k)
    % data_train: structure with the training dataset.
    % data_test: structure with the testing dataset.
    % k: the number of neighbors.
    %  
    % returns the predictions of the knn model.

    % get the classifier
    % model = knnrule(data_train, k);
    model = fitcknn(data_train.X', data_train.y', 'NumNeighbors', k);

    % get the predictions of the classifier
    % ypred = knnclass(data_test.X, model);
    ypred = predict(model, data_test.X')';  

end