function [X, c, l] = mf(D, X)
% MF Max flow. Ford�Fulkerson algorithm
%   ������ � ������������ ������
%   D - ��������� (������� ���������)
%   X - �������� ��������� ������
narginchk(1, 2);
[m, n] = size(D);
assert(m == n);
if nargin < 2
    X = zeros(m);
end
s = 1;
t = m;
for i = 1:1000
    [q, l] = searchFlow(D, X, s, t);
    if isnan(q(t))
        c = sum(X(s, :));
        return;
    end
    
    % �������������� ������
    path = t;
    prev = q(t);
    while prev ~= 0
        path(end+1) = prev;
        prev = q(abs(prev));
    end
    U = [path(end:-1:2); abs(path(end-1:-1:1))];
    
    X = updateFlow(D, X, U);
end
end

function [g, l] = searchFlow(C, X, s, t)
%% ����� ������
% ��� 1. ������������
[m, ~] = size(C);
it = 1;
ic = 1;

g = nan(1, m); % �����
g(s) = 0;
p = zeros(1, m); % ��� �����-�� �����
p(s) = 1;
l = s; % ���������� ����
i = s;

for count = 1:1000
    % ��� 2
    % �������� ������������ ���� � ����� �� i
    for j = find(X(i, :) < C(i, :) & isnan(g))
        g(j) = i;
        it = it + 1;
        p(j) = it;
        l(end+1) = j;
    end
    
    % ��� 3
    % �������� ������������ ���� � ����� � i
    for j = find((X(:, i) > 0)' & isnan(g))
        g(j) = -i;
        it = it + 1;
        p(j) = it;
        l(end+1) = j;
    end
    
    if ~isnan(g(t))
        % ��������������� ����� ������
        return;
    end
    
    ic = ic + 1;
    i = find(p == ic, 1);
    if isempty(i)
        return;
    end
end;
end

function X = updateFlow(C, X, U)
up = U(1, :) > 0;
upi = sub2ind(size(X), abs(U(1, up)), U(2, up));
alphas(up) = C(upi) - X(upi);

lw = U(1, :) < 0;
lwi = sub2ind(size(X), U(2, lw), abs(U(1, lw)));
alphas(lw) = X(lwi);

alpha = min(alphas);

X(upi) = X(upi) + alpha;
X(lwi) = X(lwi) - alpha;
end