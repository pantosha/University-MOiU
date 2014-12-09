m = 2;
n = 4;
c = [1; 1; -2; -3];
A = [1 -1 3 -2; 1 -5 11 -6];
b = [1; 9];
y = [1.5; -0.5];
Jb = [1 2];

Ab = A(:,Jb);
B = Ab^-1;

for i = 1:1000

%1
Nb = B*b;

%2
if Nb > 0
    disp('Find solve');
	disp(y);
    break
end

%3
jk = min(Jb(Nb < 0));
k = find(Jb == jk);
Bk = B(k,:);
Jn = setdiff(1:n, Jb);

mj = Bk*A(:, Jn);

if all(mj >= 0)
    disp('No solve');
    break;
end

%4
j = find(mj < 0);
jJn = Jn(j);
steps = (c(jJn)-(A(:,jJn)')*y)'./mj(j);
[step, jStep] = min(steps);
j0 = min(jJn(jStep));

%5
Jb(k) = j0;
y = y + step*Bk';

%6
z = B*A(:,j0); 
M = eye(m);
M(:, k) = -z./z(k);
M(k, k) = 1/z(k);
B = M*B;
end
