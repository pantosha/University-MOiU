function [x, m, FB] = resourceAllocation(table)
[n, c] = size(table);
B = zeros(n, c);
x = zeros(1, n);
x0k = zeros(n, c);
x0k(1, :) = 0:c-1;
B(1, :) = table(1,:);
for i = 2:n
    for y = 1:c
        z = 1:y;
        [B(i, y), ind] = max(table(i, z) + B(i-1, y - z + 1));
        x0k(i, y) = ind-1;
    end;
end;
FB = B;
m = max(max(B));
rest = c - 1;
while rest > 0
    [i, j] = find(B == max(max(B)), 1);
    x(i) = x0k(i, j);
    rest = rest - x(i);
    B = B(1:i-1, 1:rest+1);
end
end