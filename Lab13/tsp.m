function [cycle, r] = tsp(C)
%TSP Summary of this function goes here
%   Detailed explanation goes here
r = inf;
cycle = [];
[m, n] = size(C);
tasks = C;
for count = 1:1000
    if isempty(tasks)
        break;
    end
    D = tasks(:, :, 1);
    tasks(:, :, 1) = [];
    X = ap(D);
    c = D.*X;
    c = sum(c(~isnan(c)));
    if c >= r
        continue;
    end
    [minCycle, cycleCount] = findCycles(X);
    assert(~isempty(minCycle));
    if cycleCount == 1
        cycle = minCycle;
        r = c;
        continue;
    end
    
    U = [minCycle(1:end-1); minCycle(2:end)];
    newTasks = ones(m, n, size(U, 1));
    for i = 1:size(U, 1)
        newTasks(:, :, i) = D.*newTasks(:, :, i);
    end
    i = U(1, :);
    j = U(2, :);
    k = 1:size(U, 1);
    newTasks(sub2ind(size(newTasks), i, j, k)) = inf;
    tasks = cat(3, tasks, newTasks);
end
end

function [minCycle, cycleCount] = findCycles(X)
% поиск цикла
cycleCount = 0;
minLength = inf;
cycle = findCycle(X);
while ~isempty(cycle)
    if length(cycle) < minLength
        minCycle = cycle;
        minLength = length(cycle);
    end
    U = [cycle(1:end-1); cycle(2:end)];
    X(sub2ind(size(X), U(:, 1), U(:, 2))) = 0;
    cycle = findCycle(X);
    cycleCount = cycleCount + 1;
end
end

function e = findCycle(M)
% Link to author: http://e-maxx.ru/algo/finding_cycle
color_empty = 0;
color_start = 1;
color_visit = 2;

cycle_start = 0;
cycle_end = 0;

out = M;
[m, n] = size(out);
assert(m == n);

c = zeros(m, 1); % статус вершин
p = zeros(m, 1); % откуда пришёл в вершину

for i = 1:m
    if dfs(i)
        break;
    end
end

if cycle_start ~= 0
    cycle = [cycle_start, cycle_end];
    prev = p(cycle_end);
    while prev ~= 0
        cycle(end+1) = prev;
        prev = p(prev);
    end
    e = cycle(end:-1:1);
else
    e = [];
end
    function b = dfs(v)
        c(v) = color_start;
        rowIndexes = find(out(v, :));
        for to = rowIndexes(:)'
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