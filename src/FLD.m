function [y_pred] = FLD(data_train, data_test)
    % wrapper for the function fld of the stprtool.
    % returns the predictions given by the classifier.

    % data_train -> structure with the dataset (only used to get the classes).
    % data_test -> data structure with the samples to be classified.
    model = fld(data_train);
    ypred = linclass(data_test, model);

end