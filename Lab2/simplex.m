function [x, jb] = simplex(c, A, b, x)
%SIMPLEX  Simplex method.
if A*x ~= b
    error('������ x �� �������� ���������� ������.');
end
jb = find(x);
m = length(jb);
B = eye(m)/(A(:, jb));
for i = 1:100
    jn = setdiff(1:length(A), jb);
    % ������ �����������
    u = c(jb)'*B;
    % ������
    deltas = u*A(:, jn) - c(jn)';
    if deltas >= 0
        % ����� �������
        return;
    end
    % ��� 3
    j0 = min(jn(deltas < 0));
    z = B*A(:, j0);
    if all(z <= 0)
        warning('��� �������');
        return;
    end
    % ��� 4
    iz = find(z > 0);
    [teta, ns] = min(x(jb(iz))./z(iz));
    s = iz(ns);
    
    % ��� 5
    x(jn) = 0;
    x(j0) = teta;
    x(jb) = x(jb) - teta.*z;
    jb(s) = j0;
    
    % ��� 6
    M = eye(m);
    M(:, s) = -z./z(s);
    M(s, s) = 1/z(s);
    B = M*B;
end
warning('����������� ������������');
end