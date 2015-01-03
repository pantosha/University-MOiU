function x = simplex2(c, A, b)
% SIMPLEX2 Two-phase simplex method.

[m, n] = size(A);
lz = find(b < 0);
A(lz, :) = -A(lz, :);
b(lz) = -b(lz);

ce = -[zeros(n, 1); ones(m, 1)];
Ae = [A eye(m)];
initx = [zeros(n, 1); b];
% TODO: catch exception
x = simplex(ce, Ae, b, initx);

% Analyze result
assert(all(x(n+1:end) < eps), 'Task has no solution');
% TODO: Basis must be analyzed
x = simplex(c, A, b, x(1:n));
end