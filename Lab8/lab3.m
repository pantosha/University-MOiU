table = [0 4 4 6 9 12 12 15 16 19 19 19;
    0 1 1 1 4 7 8 8 13 13 19 20;
    0 2 5 6 7 8 9 11 11 13 13 18;
    0 1 2 4 5 7 8 8 9 9 15 19;
    0 2 5 7 8 9 10 10 11 14 17 21
    ];
expX = [7 0 2 0 2];

% table = [0 1 2 2 2 3 5 8 9 13 14;
%          0 1 3 4 5 5 7 7 10 12 12;
%          0 2 2 3 4 6 6 8 9 11 17;
%          0 1 1 1 2 3 9 9 11 12 15;
%          0 2 7 7 7 9 9 10 11 12 13;
%          0 2 5 5 5 6 6 7 12 18 22
%         ];
% x0 = [0 0 0 0 0 10];

[actX, m, B] = resourceAllocation(table);
disp(B);
disp(m);
disp(actX);

%% Run tests
result = run(ResourceAllocationTest);
disp(result);