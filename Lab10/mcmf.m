function [X, c] = mcmf(C, a, X, B, E)
%MCMF Min cost max flow
%   Задача о потоке минимальной стоимости
%   C - стоимость (матрица смежности)
%   a - вектор, содержащий значение стока / истока каждого узла
%   X - значение базисного потока
%   B - базис

narginchk(3, 5);
if nargin < 5
    E = C ~= 0;
    if nargin < 4
        B = X > 0;
    end
end
E = logical(E);
B = logical(B);

% Подсчитать потенциалы базисных узлов
[m, n] = size(C);
assert(m == n);

for counter = 1:100
    u = nan(m, 1);
    u(1) = 0;
    while any(isnan(u))
        for i = find(isnan(u))'
            for j = find(B(i, :))
                if ~isnan(u(j))
                    u(i) = C(i, j) + u(j);
                    break;
                end
            end
            
            if ~isnan(u(i))
                continue;
            end
            
            for j = find(B(:, i))'
                if ~isnan(u(j))
                    u(i) = u(j) - C(j, i);
                    break;
                end
            end
        end
    end
    
    NB = xor(E, B);
    [i, j] = find(NB);
    deltas = u(i) - u(j) - C(sub2ind([m,n], i, j));
    
    if all(deltas <= 0)
        c = sum(sum(C.*X));
        return;
    end
    
    [~, k] = max(deltas);
    i0 = i(k); j0 = j(k);
    testLoopPlan = B;
    testLoopPlan(i0, j0) = 1;
    cycle = findCycle(testLoopPlan, [i0, j0]);
    assert(~isempty(cycle));
    
    U = [cycle(1:end-1); cycle(2:end)];
    up = sub2ind(size(E), U(1, :), U(2, :));
    up = up(E(up));
    um = sub2ind(size(E), U(2, :), U(1, :));
    um = um(E(um));
    
    [teta, k] = min(X(um));
    X(up) = X(up) + teta;
    X(um) = X(um) - teta;
    
    B(um(k)) = 0;
    B(i0, j0) = 1;
end
warning('overflow');
end

function e = findCycle(M, x)
% Link to author: http://e-maxx.ru/algo/finding_cycle
color_empty = 0;
color_start = 1;
color_visit = 2;

cycle_start = 0;
cycle_end = 0;

out = triu(double(or(M, M')), 1);
[m, n] = size(out);
assert(m == n);

c = zeros(m, 1); % статус вершин
p = zeros(m, 1); % откуда пришёл в вершину
c(x(1)) = color_start;
c(x(2)) = color_start;
p(x(2)) = x(1);

if dfs(x(2))
    cycle = [cycle_start, cycle_end];
    prev = p(cycle_end);
    while prev ~= 0
        cycle(end+1) = prev;
        prev = p(prev);
    end
    e = cycle(end:-1:1);
end
    function b = dfs(v)
        rowIndexes = find(out(v, :));
        colIndexes = find(out(:, v));
        lv = union(rowIndexes, colIndexes);
        lv = setdiff(lv, p(v));
        for to = lv(:)'
            if c(to) == color_empty
                p(to) = v;
                if dfs(to)
                    b = true;
                    return;
                end
            elseif c(to) == color_start
                cycle_end = v;
                cycle_start = to;
                b = true;
                return;
            end
        end
        c(v) = color_visit;
        b = false;
    end
end