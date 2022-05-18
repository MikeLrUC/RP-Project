function [y_pred] = FLD(data_train, data_test)
    % wrapper for the function fld of the stprtool.
    % returns the predictions given by the classifier.

    % data_train -> structure with the dataset (only used to get the classes).
    % data_test -> data structure with the samples to be classified.
    
    
    % fld uses classes starting at 1.
    data_train.y = data_train.y + 1;
    
    model = fld(data_train);
    ypred = linclass(data_test.X, model);
    
    %the output will also have the predictions starting at 1.
    ypred = ypred - 1; % make the classes start at 0.

end