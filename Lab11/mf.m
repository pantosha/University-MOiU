function [X] = mf(D, X)
% MF Max flow. Ford�Fulkerson algorithm
%   ������ � ������������ ������
%   C - ��������� (������� ���������)
%   X - �������� ��������� ������
%   B - �����
narginchk(1, 2);
[m, n] = size(D);
assert(m == n);
if nargin < 2
    X = zeros(m);
end
s = 1;
t = m;
for i = 1:1000
    q = searchFlow(D, X, s, t);
    if q(t) == 0
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

function g = searchFlow(C, X, s, t)
%% ����� ������
% ��� 1. ������������
[m, ~] = size(C);
it = 1;
ic = 1;

g = zeros(1, m); % �����
g(s) = 0;
p = zeros(1, m); % ��� �����-�� �����
p(s) = 1;
l = false(1, m); % ���������� ����
l(s) = true;
i = s;

for count = 1:1000
    % ��� 2
    % �������� ������������ ���� � ����� �� i
    for j = find(X(i, :) < C(i, :) & ~l)
        g(j) = i;
        it = it + 1;
        p(j) = it;
        l(j) = true;
    end
    
    % ��� 3
    % �������� ������������ ���� � ����� � i
    for j = find((X(:, i) > 0)' & ~l)
        g(j) = -i;
        it = it + 1;
        p(j) = it;
        l(j) = true;
    end
    
    if l(t)
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