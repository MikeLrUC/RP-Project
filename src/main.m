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

%% PCA (Feature reduction)
figure_number = 1;
%--- Scenario A (Coronary Heart Disease) ---
% normalize data
dataCHD_normalized = {scalestd(dataCHD{1,1}), scalestd(dataCHD{1,2})};

% plot training data
% nao sei como fazer, visto que temos um monte de features. Para duas era
% facil. Assim nao sei que plots fazer (combinacoes todas?).
% Iriamos ter sum(1 : 14 == dim - 1) plots (dim = 15)

% PCA (Principal Component Analysis)
model_pca = pca(dataCHD_normalized{1,1}.X);

% plot eigenvalues (Scree plot)
% https://docs.displayr.com/wiki/Kaiser_Rule
% https://en.wikipedia.org/wiki/Factor_analysis
figure(figure_number);
figure_number = figure_number + 1;
n_eigvals = size(model_pca.eigval,1);
hold on;
plot(1 : n_eigvals, model_pca.eigval, '-o');
yline(1);
title('Coronary Heart Disease train data PCA eigenvalues');
legend('eigenvalues', 'Kaiser treshold');
hold off;

% In the Scree plot we can see that there are 4 eigenvalues that are higher
% than 1. Using the Kaiser rule, we would choose those 4 eigenvalues.
% Using the Scree test, I think that we would choose every single
% eigenvalue due to the fact that they do not stabilize.

% cumulative variance
cumulative_variance_pca = zeros(1, dataCHD_normalized{1,1}.dim);

temp = 0;
for i = 1 : dataCHD_normalized{1,1}.dim
    temp = temp + model_pca.eigval(i, 1);
    cumulative_variance_pca(1, i) = temp;
end
cumulative_variance_pca = cumulative_variance_pca / sum(model_pca.eigval);

% plot the cumulative variance
figure(figure_number);
figure_number = figure_number + 1;
hold on;
plot(1 : dataCHD_normalized{1,1}.dim, cumulative_variance_pca);
plot(1 : dataCHD_normalized{1,1}.dim, ones(1, dataCHD_normalized{1,1}.dim) * 0.8) % threshold of 80% variance
title('cumulative variance plot pca');
legend('cumulative variance', '80% threshold');
hold off;

% get the model with dim = 4.
dim_pca = sum(model_pca.eigval(:, 1) > 1);
model_pca = pca(dataCHD_normalized{1,1}.X, dim_pca); % acredito que os novos dados 
% sejam tambem diminuidos a 4 dimensoes por este modelo.

% Dimensionality of the data was reduced from 15 to 4
dataCHD_normalized_proj_pca_train = linproj(dataCHD_normalized{1,1}.X, model_pca);
% com 4 dimensoes ja seriam apenas 6 plots.

% percentage of variance preserved
R_pca = sum(model_pca.eigval(1 : dim_pca, 1).^2) / sum(model_pca.eigval(:, 1).^2);

%% LDA (Feature reduction)
% Como usar LDA (Linear Discriminant Analysis) para fazer feacture
% reduction? Eu num sei.
% A funcao lda parece retornar as mesmas coisas que a pca, mas nao sei como
% os usaria.

copy_dataCHD_normalized_train = dataCHD_normalized{1,1};
copy_dataCHD_normalized_train.y = copy_dataCHD_normalized_train.y + 1;
model_lda = lda(copy_dataCHD_normalized_train);
model_lda.eigval = real(diag(model_lda.eigval)); % the eigen values are complex

% plot eigenvalues (Scree plot)
% https://docs.displayr.com/wiki/Kaiser_Rule
% https://en.wikipedia.org/wiki/Factor_analysis
figure(figure_number);
figure_number = figure_number + 1;
n_eigvals = size(model_lda.eigval,1);
hold on;
plot(1 : n_eigvals, model_lda.eigval, '-o');
yline(1);
title('Coronary Heart Disease train data LDA eigenvalues');
legend('eigenvalues', 'Kaiser treshold');
hold off;

% In the Scree plot we can see that there is 1 eigenvalue that are higher
% than 1. Using the Kaiser rule, we would choose that eigenvalue.
% Using the Scree test, we would also choose one eigenvalue, because the
% rest are stabilized.

% cumulative variance
cumulative_variance_lda = zeros(1, copy_dataCHD_normalized_train.dim);

temp = 0;
for i = 1 : copy_dataCHD_normalized_train.dim
    temp = temp + model_lda.eigval(i, 1);
    cumulative_variance_lda(1, i) = temp;
end
cumulative_variance_lda = cumulative_variance_lda / sum(model_lda.eigval);

% plot the cumulative variance
figure(figure_number);
figure_number = figure_number + 1;
hold on;
plot(1 : copy_dataCHD_normalized_train.dim, cumulative_variance_lda);
plot(1 : copy_dataCHD_normalized_train.dim, ones(1, copy_dataCHD_normalized_train.dim) * 0.8); % threshold of 80% variance
title('cumulative variance plot lda');
legend('cumulative variance', '80% threshold');
hold off;

% LDA (Linear Discriminant Analysis)
dim_lda = sum(model_lda.eigval(:, 1) > 1);
model_lda = lda(copy_dataCHD_normalized_train, dim_lda);
model_lda.eigval = real(diag(model_lda.eigval)); % the eigen values are complex

% Dimensionality of the data was reduced from 15 to 4
dataCHD_normalized_proj_lda_train = linproj(copy_dataCHD_normalized_train.X, model_lda);
% com 4 dimensoes ja seriam apenas 6 plots.

% percentage of variance preserved
R_lda = sum(model_lda.eigval(1 : dim_lda, 1).^2) / sum(model_lda.eigval(:, 1).^2);


%% box plots the features per classe and Kruskal Wallis (Feature Assessment)
dataCHD_normalized_train = dataCHD_normalized{1, 1};
class1 = dataCHD_normalized_train.X(:, dataCHD_normalized_train.y(1, :) == 1); % has CHD
class2 = dataCHD_normalized_train.X(:, dataCHD_normalized_train.y(1, :) == 0); % does not have CHD
figure(figure_number);
figure_number = figure_number + 1;


% for Kruskal Wallis
KW_results = cell(dataCHD_normalized_train.dim, 3);
chi_sqrt_values = zeros(1, dataCHD_normalized_train.dim);

for current_feature = 1: dataCHD_normalized_train.dim
% for current_feature = 1: 1
    subplot(3, 5, current_feature);
    hold on;
    c1_current_feature = class1(current_feature, :); % obtain the values for the current feature of class 1
    c2_current_feature = class2(current_feature, :); % obtain the values for the current feature of class 2
    x = [c1_current_feature, c2_current_feature]; % join the previously computed arrays
    g = [repmat({'CHD'}, size(c1_current_feature)), repmat({'No CHD'}, size(c2_current_feature))]; % create an array with the label of each entry in the joined array
    boxplot(x, g); % boxplot the data
    % I had to do it this way because the number of samples per class is
    % different.
    title(independent_vars_names(1, current_feature));

    [KW_results{current_feature, 1}, KW_results{current_feature, 2}, KW_results{current_feature, 3}] = kruskalwallis(x, g, 'off'); % off so it does not display the images
    chi_value = KW_results{current_feature, 2}(2, 5); % it is a cell array, need to store it so i can access the value in the first position
    chi_sqrt_values(1, current_feature) = chi_value{1,1};

    hold off;
end
clear x g chi_value c1_current_feature c2_current_feature class1 class2 current_feature;

% print features chi square values
[~, indexes] = sort(chi_sqrt_values);
disp('least discriminant.')
for i = 1 : dataCHD_normalized_train.dim
    index = indexes(1, i);
    class_ = independent_vars_names(1, index);
    fprintf("%f -> %s\n", chi_sqrt_values(1, index), class_{1,1});
end
disp('most discriminant.')
clear indexes index class_ i;
% correlation matrix (heatmap)

% correlation matrix
corr_matrix = corr(dataCHD_normalized_train.X(:, :)');

% heatmap
feature_names = independent_vars_names;
figure(figure_number);
figure_number = figure_number + 1;
heatmap(corr_matrix, 'XData', feature_names, 'YData', feature_names );

%% Distribution model assessment
% verify if the feature's data is drawn from the normal distribution
% some models need this assumption

% using histograms
figure(figure_number);
figure_number = figure_number + 1;
n_bins = 25;
for i = 1 : dataCHD_normalized_train.dim
    % histogram and normal curve fitted (all classes)
    subplot(3, 5, i);
    histfit(dataCHD_normalized_train.X(i, :), n_bins);
    title(independent_vars_names(1, i));
    title(independent_vars_names(1, i));
end


% using Kolmogorov-Smirnov
% save kstest results
n_classes = size(unique(dataCHD_normalized_train.y), 2);
KS_results = cell(1, n_classes); % {1,1} -> NO CHD, {1, 2} -> CHD
class_labels = {'NO CHD', 'CHD'};

significance_level = 0.05; % significance level of 5%
x_values = linspace(-5, 5); % for the standard CDF plot
for e = 1 : n_classes
    figure(figure_number);
    figure_number = figure_number + 1;
    subplot_inx = 1;
    d = dataCHD_normalized_train.X(:, dataCHD_normalized_train.y == e - 1);
    KS_results_inner = cell(dataCHD_normalized_train.dim, 4);
    for i = 1 : dataCHD_normalized_train.dim
        aux = d(i, :);
        [KS_results_inner{i, 1}, KS_results_inner{i, 2}, KS_results_inner{i, 3}, KS_results_inner{i, 4}] = kstest(aux, 'alpha', significance_level);
        % histogram and normal curve fitted
        subplot(3, 5 * 2, subplot_inx);
        subplot_inx = subplot_inx + 1;
        histfit(dataCHD_normalized_train.X(i, :), n_bins);
        title(strcat(independent_vars_names(1,i), " ", class_labels(1,e)));
    
        % empirical CDF vs standard CDF
        subplot(3, 5 * 2, subplot_inx);
        subplot_inx = subplot_inx + 1;
        hold on;
        cdfplot(dataCHD_normalized_train.X(i, :));
        plot(x_values,normcdf(x_values,0,1),'r-')
        legend('Empirical CDF','Standard Normal CDF','Location','best')
        hold off;
        title(strcat(independent_vars_names(1,i), " ", class_labels(1,e)));
    end
    KS_results{1, e} = KS_results_inner;
end
clear KS_results_inner d aux x_values i e subplot_inx;

%%% the results of the Kolmogorov-Smirnov tests show that thw data is not
%%% normal with a significance level of 5%
