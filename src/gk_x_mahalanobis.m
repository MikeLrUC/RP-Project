function [val, k, b] = gk_x_mahalanobis(C, m, x)
    % C -> covariance matrix calculated with calculate_C
    % m -> prototype
    % x -> sample

    inv_C = inv(C);
    k = m' * inv_C* x;
    b = 0.5 * m' * inv_C * m;
    val = k - b;
end