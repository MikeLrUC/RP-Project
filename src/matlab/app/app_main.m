function app_main(scenario, scale, assess, technique, n_features)
    % Handler function for the matlab App
    % Paramenters
    %   - scenario: int (1, 2, 3) for the assignment scenario
    %   - scale: bool to scale the datapoints
    %   - assess: bool to make feature assessment
    %   - technique: Feature Selection/Reduction Technique ("None", "KW", "LDA", "PCA")
    %   - n_features: Number of most discriminant Features chosen by user, based on the technique
    %   - 
    %
    
    % Close all previous Plots
    close all;
    
    %%% 1 - Load Scenario Data %%%
    [data_sc1, data_sc2, data_sc3, feature_names] = load_dataset('data/heart_2020_cleaned.csv');
    switch scenario
        case "1"
            data = data_sc1;
            class_labels = {'NO CHD', 'CHD'};
        case "2"
            data = data_sc2;
            class_labels = {'No HD', 'HD'};
        case "3" 
            data = data_sc3;
            class_labels = {'No HD', 'HD', 'HDC'};
        otherwise
            disp("Wrong Scenario Value!!")
    end
    
    
    %%% 2 - Pre-Processing: Scaling %%%
    if scale
       data{1} = scalestd(data{1}); % Train Data
       data{2} = scalestd(data{2}); % Test Data
    end
    
    
    %%% 3 - Feature Assessment %%%
    if assess
        
        n_classes = size(unique(data{1}.y), 2);
        KS_results = cell(1, n_classes); 
        
        % Significance Level
        significance_level = 0.05; 
        
        % Plotting Vars
        n_bins = 25;
        x_values = linspace(-5, 5); % for the standard CDF plot
        
        % For each scenario class
        for c = 1 : n_classes
            figure;
            
            % Select Class datapoints
            class_datapoints = data{1}.X(:, data{1}.y == c - 1);
            
            % Other Saving and Plotting Variables
            KS_results_inner = cell(data{1}.dim, 4);
            subplot_idx = 1;
            
            % For each feature
            for i = 1 : data{1}.dim
                aux = class_datapoints(i, :);
                [KS_results_inner{i, 1}, KS_results_inner{i, 2}, KS_results_inner{i, 3}, KS_results_inner{i, 4}] = ...
                    kstest(aux, 'alpha', significance_level);
                
                % Histogram and Normal curve fitted
                subplot(3, 5 * 2, subplot_idx);
                subplot_idx = subplot_idx + 1;
                
                histfit(aux, n_bins);
                
                title(strcat(feature_names(1, i), " | ", class_labels(c)));

                % Empirical CDF vs Standard CDF
                subplot(3, 5 * 2, subplot_idx);
                subplot_idx = subplot_idx + 1;
                
                hold on;
                    cdfplot(aux);
                    plot(x_values, normcdf(x_values, 0, 1), 'r-')
                    legend('Empirical CDF','Standard Normal CDF','Location','best')
                hold off;
                
                title(strcat(feature_names(1, i), " | ", class_labels(c)));
            end
            KS_results{c} = KS_results_inner;
        end
        clear KS_results_inner class_datapoints aux x_values i c subplot_idx; 
    end
    
    %%% 4 - Feature Selection/Reduction %%%
    
    switch technique
        case "CORR"
            disp("Maybe one day")
        case "KW"
            [data{1}, data{2}, KW_results, chi_sq_results] = kruskalwallis_test(data{1}, data{2}, n_features, true, feature_names);
            figure; plot(1:length(chi_sq_results), sort(chi_sq_results))
        case "PCA"
            [data{1}, data{2}, model] = PCA(data{1}, data{2}, n_features);
            figure; hold on; yline(1); plot(1:length(model.eigval), model.eigval); hold off;
        case "LDA"
            [data{1}, data{2}, model] = LDA(data{1}, data{2}, n_features);
            figure; hold on; yline(1); plot(1:length(model.eigval), model.eigval); hold off;
        otherwise
            disp("No Feature Selection/Reduction technique was chosen!!")
    end
    
    
    %%% 5 - Hyperparameters Tunning %%%
    
    %%% 6 - Classification %%%
    
end