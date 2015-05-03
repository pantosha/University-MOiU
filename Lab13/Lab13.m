C = [
    inf 10 25 25 10
    1 inf 10 15 2
    8 9 inf 20 10
    14 10 24 inf 15
    10 8 25 27 inf
    ];
expX = [1 5 2 3 4 1];
[actX, c] = tsp(C);
disp(actX);
disp(c);
%assert(all(actX(:) == expX(:)));