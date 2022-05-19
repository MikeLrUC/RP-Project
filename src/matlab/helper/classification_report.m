function report = classification_report(y_true, y_pred, class_labels)
    % A similar function to the sklearn.metrics.classification_report in python
    
    % Put arrays in the same shape
    y_true = y_true(:);
    y_pred = y_pred(:);
    
    % Some vars
    n_classes = length(class_labels);
    report.classes = cell(1, n_classes);
    classes = 0 : n_classes - 1;
    latex = "\begin{table}\begin{tabular}{ |c|c|c|c|c| }\hline\textbf{Metrics} & \textbf{Recall} & \textbf{Precision} & \textbf{Specificity} & \textbf{f1} \\ \hline ";
    for i = 1 : n_classes
        % Confusion Matrix for target class in 1st position
        [cm, order] = confusionmat(y_true, y_pred, 'Order', classes);
        report.classes{i}.cm = cm;
        report.classes{i}.order = order;
        
        % True/False Positives/Negatives
        TP = sum(cm(1, 1), 'all');
        TN = sum(cm(2:end, 2:end), 'all');
        FP = sum(cm(2:end, 1), 'all');
        FN = sum(cm(1, 2:end), 'all');
        
        % Class Metrics 
        report.classes{i}.recall = round(TP / (TP + FN), 2);               % Sensitivity, recall, hit rate, or true positive rate (TPR)         
        report.classes{i}.specificity = round(TN / (TN + FP), 2);          % Specificity, selectivity or true negative rate (TNR)
        report.classes{i}.precision = round(TP / (TP + FP), 2);            % Precision or positive predictive value (PPV)
        report.classes{i}.f1 = round((2 * TP) / (2 * TP + FP + FN), 2);    % harmonic mean of precision and sensitivity: 
        classes = [classes(2:end), classes(1)];
        % Latex line
        latex = latex + sprintf("\\textit{Class %s} & %.2f & %.2f & %.2f & %.2f \\\\ \\hline ", ...
            class_labels{i},                                                        ...
            report.classes{i}.recall,                                               ...
            report.classes{i}.precision,                                            ...
            report.classes{i}.specificity,                                          ...
            report.classes{i}.f1                                                    ...
        );
    end
    report.accuracy = round(mean(y_true == y_pred), 2);
    report.latex = latex + "\end{tabular} \end{table}";
end