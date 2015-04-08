function [x, m, FB] = resourceAllocation(table)
[n, c] = size(table);
B = zeros(n, c);
x = zeros(1, n);
x0k = zeros(n, c);
x0k(1, :) = 1:c;
B(1, :) = table(1, :);
for i = 2:n
    for y = 1:c
        z = 1:y;
        [B(i, y), ind] = max(table(i, z) + B(i-1, y - z + 1));
        x0k(i, y) = ind-1;
    end;
end;
FB = B;
m = B(n, c);
i = n;
j = c;
x(i) = x0k(i, j);
B(i, :) = -inf;
col = c-x(i);
ost = col-1;
if ost == 0
    return;
end;
for k = 2:n-1
    [i, ~] = find(B(:, col) == max(B(:, col)), 1, 'last');
    i = i(1);
    x(i) = x0k(i, col);
    B(i, :) = -inf;
    col = col - x(i);
    ost = ost - x(i);
end;
[i, ~] = find(B(:, col) == max(B(:, col)), 1, 'last');
i = i(1);
x(i) = ost;
end
