function [ypred] = SVM(data_train, data_test, C, Gamma)
    % data_train: structure with the training dataset.
    % data_test: structure with the testing dataset.
    % C: used for the box constraints.
    % Gamma: used for the kerne scale.
    %
    % return the predictions of the model.

   % Create Model
   t = templateSVM('KernelFunction', 'rbf', 'BoxConstraint', C, 'KernelScale', sqrt(1 / (2 * Gamma)), 'Solver', 'SMO');
   model = fitcecoc(data_train.X', data_train.y', 'Coding', 'onevsall', 'Learners', t);

   ypred = predict(model, data_test.X');
end