function [X] = transProblem(C, a, b)
% C - цены на перевозку
% a - производство
% b - потребление

% условие общего баланса
assert(sum(a) == sum(b), 'No solve');

[m, n] = size(C);
[X, B] = mincost(C, a, b);

% ћетод потенциалов
for l=1:100
    disp(X);
    disp(B);
    %disp(sum(sum(C.*X)));
    % 1. ѕотенциалы (дл€ базисных элементов)
    potentialsIExcl = [];
    potentialsJExcl = [];
    
    u = zeros(length(a), 1);
    v = zeros(1, length(b));
    
    shouldInitialize = true;
    
    while (length(potentialsIExcl) + length(potentialsJExcl) ~= length(a) + length(b))
        changedCount = 0;
        disp('.')
        for i=1:length(a)
            for j=1:length(b)
                if (B(i, j) == 1)
                    if (shouldInitialize)
                        %set start value
                        u(i) = 0;
                        potentialsIExcl(length(potentialsIExcl) + 1) = i;
                        shouldInitialize = false;
                        changedCount = changedCount + 1;
                    end
                    
                    if (~any(potentialsIExcl == i) && any(potentialsJExcl == j))
                        u(i) = C(i, j) - v(j);
                        potentialsIExcl(length(potentialsIExcl) + 1) = i;
                        changedCount = changedCount + 1;
                    end
                    
                    if (~any(potentialsJExcl == j) && any(potentialsIExcl == i))
                        v(j) = C(i, j) - u(i);
                        potentialsJExcl(length(potentialsJExcl) + 1) = j;
                        changedCount = changedCount + 1;
                    end
                end
            end
        end
        
        if (changedCount == 0)
            shouldInitialize = true;
        end
    end
    
    % Ќаходим оценки (дл€ небазисных эементов)
    Delta = zeros(m, n);
    for i = 1:m
        for j = 1:n
            if(X(i, j) == 0)
                Delta(i, j) = u(i) + v(j) - C(i, j);
            end
        end
    end
    disp('.')
    % 3 ѕровер€ем оптимальность плана
    if(all(Delta <= 0))
        disp(X);
        disp('Find solve');
        disp(sum(sum(C.*X)));
        break;
    end
    
    %4 находим максимальный положительный элемент
    d = max(max(Delta));
    [i0, j0] = find(Delta == d);
    
    %5
    testLoopPlan = B;
    testLoopPlan(i0(1), j0(1)) = 1;
    loopIndexes = GetLoopElements(testLoopPlan);
    
    teta0 = inf;
    teta0i = 1;
    teta0j = 1;
    currentSignum = -1;
    
    passedPoints = zeros(m, n);
    passedPoints(i0(1), j0(1)) = 1;
    
    prevI = i0(1);
    prevJ = j0(1);
    
    while true
        %  1 - горизонтальные
        % -1 - вертикальные
        if (currentSignum == 1)
            for i=1:m
                if ((i ~= prevI) && (loopIndexes(i, prevJ) == 1))
                    prevI = i;
                    break;
                end
            end
        else
            for j=1:n
                if ((j ~= prevJ) && (loopIndexes(prevI, j) == 1))
                    prevJ = j;
                    break;
                end
            end
        end
        
        if ((prevI == i0(1)) && (prevJ == j0(1)))
            break;
        end
        
        passedPoints(prevI, prevJ) = currentSignum;
        %change sign
        currentSignum = -currentSignum;
        
        if (X(prevI, prevJ) <= teta0 && currentSignum == 1)
            teta0 = X(prevI, prevJ);
            teta0i = prevI;
            teta0j = prevJ;
        end
    end
    %6
    for i=1:m
        for j=1:n
            if (passedPoints(i, j) ~= 0)
                X(i, j) = X(i, j) + passedPoints(i, j) * teta0;
            end
        end
    end
    
    %7
    testLoopPlan(teta0i, teta0j) = 0;
    B = testLoopPlan;
end
end

function [X, B] = mincost(C, a, b)
%MINCOST метод минимального элемента
%   C - цены на перевозку
%   a - производство
%   b - потребление
[m, n] = size(C);
X = zeros(m, n);
B = zeros(m, n);
for ii = 1:n+m-1
    [c, index] = min(C(:));
    if isinf(c)
        break;
    end
    [i, j] = ind2sub([m, n], index);
    
    B(i, j) = 1;
    if a(i) < b(j)
        C(i, :) = inf;
        X(i, j) = a(i);
        b(j) = b(j) - a(i);
        a(i) = 0;
    elseif a(i) > b(j)
        C(:, j) = inf;
        X(i, j) = b(j);
        a(i) = a(i) - b(j);
        b(j) = 0;
    else
        C(i, :) = inf;
        C(:, j) = inf;
        X(i, j) = a(i);
        a(i) = 0;
        b(j) = 0;
    end
end
assert(sum(a) == 0 && sum(b) == 0, 'mincost');

for i=1:m
    for j=1:n
        if B(i, j) == 0
            %пытаемс€ добавить новый элемент без цикла
            B(i, j) = 1;
            
            %проверка цикла
            bufferLoopIndexes = GetLoopElements(B);
            if (bufferLoopIndexes(i, j) == 1)
                B(i, j) = 0;
            end
        end
    end
end
end