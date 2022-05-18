function [val, k, b] = gk_x_euclidean(m, x)
    %  𝑔k(x)= 𝐦kT 𝐱 − 𝟎 . 𝟓 𝐦kT𝐦𝑘
    mk_squared = m' * m;
    k = m' * x;
    b = 0.5 * mk_squared;
    val = k - b;
end