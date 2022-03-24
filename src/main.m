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
dependent_vars_names = table.Properties.VariableNames{1, 1 : 4};
independent_vars_names = table.Properties.VariableNames{1, 5 : end};
dependent_vars = table{:, 1 : 4};
class_CHD = dependent_vars(:, 1) == 1;
class_MI = dependent_vars(:, 2) == 1;
pos_class = class_CHD | class_MI;

% create data structure for HeartDisease 
dataHD.X = table{:, 5 : end}';
dataHD.y = pos_class';
dataHD.dim = size(dataHD.X, 1);
dataHD.num_data = size(dataHD.X, 2);
dataHD.name = 'Heart Diseases dataset.';

% clear memory
clear class_MI class_CHD pos_class;

% create data structure for HeartDisease with comorbidities
class_CHD = dependent_vars(:, 1) == 1;
class_KD = dependent_vars(:, 3) == 1;
class_SC = dependent_vars(:, 4) == 1;
Comorbidities = class_KD | class_SC;
pos_class = class_CHD & Comorbidities;

% create data structure
dataHDC.X = table{:, 5 : end}';
dataHDC.y = pos_class';
dataHDC.dim = size(dataHDC.X, 1);
dataHDC.num_data = size(dataHDC.X, 2);
dataHDC.name = 'CoronaryHeartDisease with Comorbidities dataset.';

% clear memory
clear dependent_vars class_KD class_SC Comorbidities class_CHD pos_class;
% the table can also be deleted