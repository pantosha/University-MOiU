function [x, jb] = simplex(c, A, b, x, jb)
%SIMPLEX  Simplex method.
if nargin < 5
    jb = find(x);
end
if any(A*x ~= b)
    error('Вектор x не является допустимым планом.');
end
[m, n] = size(A);
B = eye(m)/A(:, jb);
for i = 1:100
    jn = setdiff(1:n, jb);
    u = c(jb)'*B; % вектор потенциалов
    deltas = u*A(:, jn) - c(jn)'; % оценки
    if deltas >= 0
        % нашли решение
        return;
    end
    % Шаг 3
    j0 = min(jn(deltas < 0));
    z = B*A(:, j0);
    if all(z <= 0)
        disp('Нет решения');
        x = [];
        jb = [];
        return;
    end
    % Шаг 4
    iz = find(z > 0);
    [teta, ns] = min(x(jb(iz))./z(iz));
    s = iz(ns);
    
    % Шаг 5
    x(jn) = 0;
    x(j0) = teta;
    x(jb) = x(jb) - teta.*z;
    jb(s) = j0;
    
    % Шаг 6
    M = eye(m);
    M(:, s) = -z./z(s);
    M(s, s) = 1/z(s);
    B = M*B;
end
warning('Вероятность зацикливания');
end