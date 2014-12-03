% c = [1, 1, 1, 1, 1];
% A = [1, 1, 0, 2, 0;
%     0, -1, 1, 0, 2;
%     1, 0, -1, 1, -2;];
% b = [3, 1, -1];
%
% simplex(a, b, c);
% x_opt = [1.5, 1.5, 2.5, 0, 0];

c = [1; -3; -5; -1];
b = [5; 9];
A = [1, 4, 4, 1;
    1, 7, 8, 2];
x = [1; 0; 1; 0];

jb = find(x);
m = length(jb);
B = eye(m)/(A(:, jb));
for i = 1:10
    jn = setdiff(1:length(A), jb);
    % вектор потенциалов
    u = c(jb)'*B;
    % оценки
    deltas = u*A(:, jn) - c(jn)';
    if deltas >= 0
        disp('Find solve');
        break
    end
    % Шаг 3
    j0 = min(jn(deltas < 0));
    z = B*A(:, j0);
    if all(z <= 0)
        disp('No solve');
        break;
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