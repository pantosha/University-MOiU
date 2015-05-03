C = [
    inf 10 25 25 10
    1 inf 10 15 2
    8 9 inf 20 10
    14 10 24 inf 15
    10 8 25 27 inf
    ];

C = [inf 18 13 18 8 16 11 0
    0 inf 1 8 2 15 19 11
    1 10 inf 18 5 15 12 12
    15 16 10 inf 16 10 6 9
    2 18 14 16 inf 18 13 1
    5 19 1 19 1 inf 7 4
    5 7 16 0 0 8 inf 6
    10 8 13 10 12 3 13 inf];

expX = [1 5 2 3 4 1];
[actX, c] = tsp(C);
disp(actX);
disp(c);
%assert(all(actX(:) == expX(:)));