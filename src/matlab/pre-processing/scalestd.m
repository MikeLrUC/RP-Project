function [new_data] = scalestd(data)
% retorna uma struct com a mesma estrutura da que recebe, alterando os
% valores do data.X
    new_data = data;
    mean_ = mean(new_data.X, 2);
    std_ = std(new_data.X, 0, 2);

    new_data.X = (new_data.X - repmat(mean_, 1, size(new_data.X, 2))) ./ repmat(std_, 1, size(new_data.X, 2));
end