function cumulative_plot(values, mytitle, x_label, y_label)
    cumulative = zeros(1, length(values) + 1);
    for i = 2 : length(values) + 1
        cumulative(i) = cumulative(i - 1) + values(i - 1);
    end
    cumulative = cumulative(2 : end) / sum(values);
    scree_plot(cumulative, false, mytitle, x_label, y_label);
end