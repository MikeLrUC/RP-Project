function [dataCHD, dataHD, dataHDC, independent_vars_names] = load_dataset(file_path)
    % file_path = 'data/heart_2020_cleaned.csv'
    
    % file_path: file path to the file that contains the dataset
    % returns 3 data structures, one to each scenario.

    table = readtable(file_path);
    % obter valores com {}
    % obter o nome das colunas com table.Properties.VariableNames
    dependent_vars_names = {table.Properties.VariableNames{1, 1 : 4}};
    independent_vars_names = {table.Properties.VariableNames{1, 5 : end}};
    dependent_vars = table{:, 1 : 4};
    class_CHD = dependent_vars(:, 1) == 1; % Coronary Heart Disease
    class_MI = dependent_vars(:, 2) == 1; % Myorcardial Infarction
    classification = class_CHD | class_MI; % Coronary Heart Disease or Myorcardial Infarction (HD ficam a 1, as restantes a 0)
    
    split = 200000;
    
    % create data structure for Coronary Heart Disease (objective 3.1)
    dataCHD_train.X = table{1 : split, 5 : end}';
    dataCHD_train.y = class_CHD(1 : split, 1)';
    dataCHD_train.dim = size(dataCHD_train.X, 1);
    dataCHD_train.num_data = size(dataCHD_train.X, 2);
    dataCHD_train.name = 'Coronary Heart Diseases train dataset.';
    
    dataCHD_test.X = table{split + 1 : end, 5 : end}';
    dataCHD_test.y = class_CHD(split + 1 : end, 1)';
    dataCHD_test.dim = size(dataCHD_test.X, 1);
    dataCHD_test.num_data = size(dataCHD_test.X, 2);
    dataCHD_test.name = 'Coronary Heart Diseases test dataset.';
    
    % create data structure for HeartDisease (objective 3.2)
    dataHD_train.X = table{1 : split, 5 : end}';
    dataHD_train.y = classification(1 : split, 1)';
    dataHD_train.dim = size(dataHD_train.X, 1);
    dataHD_train.num_data = size(dataHD_train.X, 2);
    dataHD_train.name = 'Heart Diseases train dataset.';
    
    dataHD_test.X = table{split + 1: end, 5 : end}';
    dataHD_test.y = classification(split + 1: end)';
    dataHD_test.dim = size(dataHD_test.X, 1);
    dataHD_test.num_data = size(dataHD_test.X, 2);
    dataHD_test.name = 'Heart Diseases test dataset.';
    
    
    % create data structure for HeartDisease with comorbidities (objective 3.3)
    class_HD = class_CHD | class_MI; % heart disease
    class_KD = dependent_vars(:, 3) == 1; % kidney disease
    class_SC = dependent_vars(:, 4) == 1; % skin cancer
    Comorbidities = class_KD | class_SC; % skin cancer or kidney disease
    %pos_class = (class_CHD & Comorbidities) + class_CHD; % se tiver so CHD fica a 1, se tiver CHD e Comorbidities fica a 2, caso contrario fica 0
    % para o caso de terem de ser ambas, Coronary Heart Disease e
    % MyocardialInfarction.
    classification = (class_HD & Comorbidities) + class_HD; % se tiver so HD fica a 1, se tiver HD e Comorbidities fica a 2, caso contrario fica 0
    
    % create data structure
    dataHDC_train.X = table{1 : split, 5 : end}';
    dataHDC_train.y = classification(1 : split)';
    dataHDC_train.dim = size(dataHDC_train.X, 1);
    dataHDC_train.num_data = size(dataHDC_train.X, 2);
    dataHDC_train.name = 'CoronaryHeartDisease with Comorbidities train dataset.';
    
    dataHDC_test.X = table{split + 1 : end, 5 : end}';
    dataHDC_test.y = classification(split + 1 : end)';
    dataHDC_test.dim = size(dataHDC_test.X, 1);
    dataHDC_test.num_data = size(dataHDC_test.X, 2);
    dataHDC_test.name = 'CoronaryHeartDisease with Comorbidities test dataset.';
    
    % clear memory
    clear dependent_vars class_KD class_SC Comorbidities class_CHD classification class_MI class_HD;
    % the table can also be deleted
    
    dataCHD = {dataCHD_train, dataCHD_test};
    dataHD = {dataHD_train, dataHD_test};
    dataHDC = {dataHDC_train, dataHDC_test};
    
    clear dataHDC_test dataHDC_train dataCHD_test dataCHD_train dataHD_test dataHD_train;

end