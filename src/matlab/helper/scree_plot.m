function scree_plot(values, kaiser, mytitle, x_label, y_label)
    figure;
    hold on;
        if kaiser
            yline(1)    
        end
        plot(1:length(values), values, "-o")
    hold off;
    xlabel(x_label)
    ylabel(y_label)
    title(mytitle)
end