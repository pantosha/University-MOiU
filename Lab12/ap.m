function [X] = ap(C)
%AP assignment problem
D = C;
[m, n] = size(D);
assert(m == n);

D = bsxfun(@minus, D, min(C, [], 2));
D = bsxfun(@minus, D, min(D, [], 1));

for count = 1:1000
    S = zeros(2*n + 2);
    S(1, 2:n+1) = 1;
    S(n+2:end-1, end) = 1;
    
    [i, j] = find(D == 0);
    i = i + 1;
    j = j + n + 1;
    S(sub2ind(size(S), i, j)) = inf;
    [X, c, l] = mf(S);
    if c == n
        X = X(2:n+1, n+2:end-1);
        return;
    end
    l = l(2:end) - 1;
    n1 = l(l <= n);
    n2 = l(l > n) - n;
    alpha = min(min(D(n1, setdiff(1:n, n2))));
    
    D(n1, :) = D(n1, :) - alpha;
    D(:, n2) = D(:, n2) + alpha;
end
end