c = [1; -3; -5; -1];
b = [5; 9];
A = [1, 4, 4, 1;
    1, 7, 8, 2];
x = [1; 0; 1; 0];

options = optimset('Algorithm', 'simplex');
solve = linprog(-c, [], [], A, b, zeros(length(c), 1), [], [], options);
disp(solve);