% ������ � �����������

C = [
    6     4    13     4    19    15    11     8
    17    15    18    14     0     7    18     7
    3     5    11     9     7     7    18    16
    17    10    16    19     9     6     1     5
    14     2    10    14    11     6     4    10
    17    11    17    12     1    10     6    19
    13     1     4     2     2     7     2    14
    12    15    19    11    13     1     7     8
    ];
expX = [
    0     0     0     1     0     0     0     0
    0     0     0     0     0     0     0     1
    1     0     0     0     0     0     0     0
    0     0     0     0     0     0     1     0
    0     1     0     0     0     0     0     0
    0     0     0     0     1     0     0     0
    0     0     1     0     0     0     0     0
    0     0     0     0     0     1     0     0
    ];

actX = ap(C);
assert(sum(sum(C.*actX)) == 23);
assert(all(all(actX == expX)));

%%
C = [2 -1 9 4
    3 2 5 1
    13 0 -3 4
    5 6 1 2];
expX = [
    0     1     0     0
    1     0     0     0
    0     0     1     0
    0     0     0     1
    ];

actX = ap(C);
assert(all(all(actX == expX)));