% dataset metadata
%
% Binary variables have to possible values: 1 == yes, 2 == no.
%
% the dataset has 19 features
% first 4 ([CoronaryHeartDisease, MyocardialInfarction, KidneyDisease, SkinCancer])
% are the independent variables and are binary (have two possible values)
%
% the rest have different types of values (floats, strings and "binaries")
%
% [_BMI5] -> float
% [Smoking] -> binary
% [AlcoholDrinking] -> binary
% [Stroke] -> binary
% [PhysicalHealth] -> float
% [MentalHealth] -> float
% [DiffWalking] -> binary
% [Sex] -> binary (1 == male, 2 == female)
% [AgeCategory] -> floats (8.0 == 55-59, 13.0 == 80 or older, 10 == 65-69, 
% 12.0 == 75-79, 5 == 40-44, 11.0 == 70-74, etc.)
% [Race] -> 
% [Diabetic] ->
% [PhysicalActivity] ->
% [GenHealth] ->
% [SleepTime] ->
% [Asthma] ->

% csv_data = csvread('heart_2020_cleaned.csv', 1); % saltar a linha das labels
% col_names = {'CoronaryHeartDisease', 'MyocardialInfarction', 'KidneyDisease', 'SkinCancer', 'BMI5', 'Smoking', 'AlcoholDrinking', 'Stroke', 'PhysicalHealth', 'MentalHealth', 'DiffWalking', 'Sex', 'AgeCategory', 'Race', 'Diabetic', 'PhysicalActivity', 'GenHealth', 'SleepTime', 'Asthma'};

%% load the dataset
table = readtable('dataset/heart_2020_cleaned.csv');
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
dataCHD_test.X = table{1 : split, 5 : end}';
dataCHD_test.y = class_CHD(1 : split, 1)';
dataCHD_test.dim = size(dataCHD_test.X, 1);
dataCHD_test.num_data = size(dataCHD_test.X, 2);
dataCHD_test.name = 'Coronary Heart Diseases test dataset.';

dataCHD_val.X = table{split + 1 : end, 5 : end}';
dataCHD_val.y = class_CHD(split + 1 : end, 1)';
dataCHD_val.dim = size(dataCHD_val.X, 1);
dataCHD_val.num_data = size(dataCHD_val.X, 2);
dataCHD_val.name = 'Coronary Heart Diseases validation dataset.';

% create data structure for HeartDisease (objective 3.2)
dataHD_test.X = table{1 : split, 5 : end}';
dataHD_test.y = classification(1 : split, 1)';
dataHD_test.dim = size(dataHD_test.X, 1);
dataHD_test.num_data = size(dataHD_test.X, 2);
dataHD_test.name = 'Heart Diseases test dataset.';

dataHD_val.X = table{split + 1: end, 5 : end}';
dataHD_val.y = classification(split + 1: end)';
dataHD_val.dim = size(dataHD_val.X, 1);
dataHD_val.num_data = size(dataHD_val.X, 2);
dataHD_val.name = 'Heart Diseases validation dataset.';


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
dataHDC_test.X = table{1 : split, 5 : end}';
dataHDC_test.y = classification(1 : split)';
dataHDC_test.dim = size(dataHDC_test.X, 1);
dataHDC_test.num_data = size(dataHDC_test.X, 2);
dataHDC_test.name = 'CoronaryHeartDisease with Comorbidities test dataset.';

dataHDC_val.X = table{split + 1 : end, 5 : end}';
dataHDC_val.y = classification(split + 1 : end)';
dataHDC_val.dim = size(dataHDC_val.X, 1);
dataHDC_val.num_data = size(dataHDC_val.X, 2);
dataHDC_val.name = 'CoronaryHeartDisease with Comorbidities validation dataset.';

% clear memory
clear dependent_vars class_KD class_SC Comorbidities class_CHD classification class_MI class_HD;
% the table can also be deleted

% TODO 
% - Talvez fazer a separacao dos dados entre teste e validacao de forma
% random.
% - Talvez colocar as structures que sao do mesmo tipo dentro de um cell
% array:
dataCHD = {dataCHD_test, dataCHD_val};
dataHD = {dataHD_test, dataHD_val};
dataHDC = {dataHDC_test, dataHDC_val};

clear dataHDC_val dataHDC_test dataCHD_val dataCHD_test dataHD_val dataHD_test;