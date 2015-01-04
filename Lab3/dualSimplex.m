function [x] = dualSimplex(c, A, b, jb)
%DUALSIMPLEX Dual simplex method.

x = [];
[m, n] = size(A);
B = A(:, jb)^(-1);
jn = setdiff(1:n, jb);
deltas = c(jb)'*B*A(:, jn) - c(jn)';
for i = 1:100
    % Step 1
    nb = B*b;
    
    % Step 2
    if all(nb >= 0)
        x = zeros(n, 1);
        x(jb) = nb;
        return;
    end
    
    % Step 3
    kb = find(jb == min(jb(nb < 0)), 1);
    mu = B(kb, :)*A(:, jn);
    
    % Step 4
    ind = mu < 0;
    omega = inf(length(jn), 1);
    omega(ind) = -deltas(ind)./mu(ind);
    [omega0, j0n] = min(omega);
    
    % Step 5
    if isinf(omega0)
        warning('Limitations of the direct problem are inconsistent.');
        return;
    end
    
    % Step 6-7
    j0 = jn(j0n);
    jn(j0n) = jb(kb);
    jb(kb) = j0;
    
    % Step 8
    deltas = deltas + omega0.*mu;
    deltas(j0n) = omega0;
    
    % Step 9
    z = B*A(:, j0);
    M = eye(m);
    M(:, kb) = -z./z(kb);
    M(kb, kb) = 1/z(kb);
    B = M*B;
end
warning('Looping..');
end