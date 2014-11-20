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

x0 = [1; 0; 1; 0];

m = size(A, 1);

jb = find(x0);
jn = setdiff(1:length(A), jb);

B = eye(length(jb))/(A(:, jb));
% вектор потенциалов
u = c(jb)'*B;
% оценки
deltas = u*A(:, jn) - c(jn)';
if deltas >= 0
    disp('Find solve');
    break
end
jmin = min(jn(deltas < 0));
z = B*A(:, jmin);
if all(z <= 0)
    disp('No solve');
    break;
end

% Шаг 4
iz = z > 0;
[teta0, s] = min(x0(jb(iz))./z(iz));

% Шаг 5
x(jn) = 0;
x(jmin) = teta0;
x(jb) = x0(jb) - teta0.*z;
jb = union(setdiff(jb, jb(s)), jmin);