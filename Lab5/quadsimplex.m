function [x, fval] = quadsimplex(c, D, A, b)
%QUADSIMPLEX Summary of this function goes here
% f(x) = c'*x + 0.5*x'*D*x -> min
% A*x = b
c = c(:);
b = b(:);
[m, n] = size(A);

[x, jo] = GenerateBasisPlan(A, b);

if (isempty(jo))
    disp('Первая фаза не имеет решения.');
    return;
end
jz = jo;

%check for correct start plan
if ((A*x) ~= b)
    disp('Не выполняются основные ограничения');
    disp(A*x);
end
if (any(x < 0))
    disp('Не выполняются прямые ограничения');
    return;
end

navigateToFourthStep = false;

while (true)
    if (~navigateToFourthStep)
        %1 находим потенциал и оценки
        B = inv(A(:, jo));
        cx = c + D*x;
        uxTransp = -cx(jo)'*B;
        delta = (uxTransp*A)' + cx;
        
        
        Jnz = setdiff(1:n, jz);
        %2 проверяем на оптимальность
        if all(delta(Jnz) >= 0)
            fval = c'*x + 0.5*x'*D*x;
            return;
        end
        
        %3 находим минимальный индекс отрицательного элемента из Jnz,
        %индекс в Jnz
        j0 = 0;
        for i=1:length(Jnz)
            if (delta(Jnz(i)) < 0)
                j0 = Jnz(i);
                break;
            end
        end
        
    end
    
    %4 формируем систему
    % Dz*lz + Az'*y + Dzjo = 0
    % Az*lz +Aj0 = 0
    Dz = D(jz, jz);
    Az = A(:, jz);
    Dzj0 = D(jz, j0);
    Aj0 = A(:, j0);
    
    DAm = size(Dz, 1);
    DAn = size(Dz, 2);
    AAm = size(Az, 1);
    AAn = size(Az, 2);
    
    %строим матрицу Hz
    % Dz Az'
    % Az 0
    %use different dimensions because of transposed A matrix
    Hz = zeros(DAm + AAm, DAn + AAm);
    Hz(1:DAm, 1:DAm) = Dz;
    Hz((DAm + 1):(DAm + AAm), 1:AAn) = Az;
    Hz(1:AAn, (DAn + 1):(DAn + AAm)) = Az';
    
    %находим hj0
    % Dzj0
    % Aj0
    hj0 = Dzj0;
    hj0((size(Dzj0, 1) + 1):(size(Dzj0, 1) + size(Aj0, 1))) = Aj0;
    
    % обратная матрица для H
    Hinv = inv(Hz);
    % -Hz^-1 * hj0 = lz
    %                y
    bufferDirectionResult = -Hinv*hj0;
    lz = bufferDirectionResult(1:length(jz));
    y = bufferDirectionResult((length(jz) + 1):length(bufferDirectionResult));
    
    % sigm = l'Dl = Dzj0'*lz + Aj0'*y + dj0j0
    sigm = Dzj0'*lz + Aj0'*y + D(j0, j0);
    
    %5 находим шаг min teta для j = Jz
    Teta0Index = 0;
    Teta0 = inf;
    for j=1:length(jz)
        bufferTeta = 0;
        if (lz(j) < 0)
            bufferTeta = -x(jz(j))/lz(j);
            if (bufferTeta < Teta0)
                Teta0 = bufferTeta;
                Teta0Index = jz(j);
            end
        end
    end
    
    if (sigm ~= 0)
        bufferTeta = abs(delta(j0)/sigm);
        if (bufferTeta < Teta0)
            Teta0 = bufferTeta;
            Teta0Index = j0;
        end
    end
    
    if (Teta0Index == 0)
        disp('Целевая функция неограничена снизу.');
        return;
    end
    
    %6
    newPlan = zeros(length(x), 1);
    for j=1:length(newPlan)
        if (any(jz == j))
            newPlan(j) = x(j) + Teta0*lz(find(jz == j, 1));
        else
            if (j == j0)
                newPlan(j) = x(j) + Teta0;
            end
        end
    end
    x = newPlan;
    
    %7
    %a
    if (Teta0Index == j0)
        jz(length(jz) + 1) = j0;
        jz = sort(jz);
        navigateToFourthStep = false;
    else
        %b
        if (any(setdiff(jz, jo) == Teta0Index))
            jz = setdiff(jz, Teta0Index);
            jz = sort(jz);
            delta(j0) = delta(j0) + Teta0*sigm;
            
            navigateToFourthStep = true;
        else
            js = Teta0Index;
            asteriskWithoutSupport = setdiff(jz, jo);
            
            jPlus = 0;
            for j=1:length(asteriskWithoutSupport)
                es = zeros(length(jo), 1);
                es(jo == js) = 1;
                
                bufferResultWithJPlus = es'*inv(A(:, jo))*A(:, asteriskWithoutSupport(j));
                
                if (bufferResultWithJPlus ~= 0)
                    jPlus = asteriskWithoutSupport(j);
                    break;
                end
            end
            
            if (jPlus ~= 0)
                %c
                jo = setdiff(jo, Teta0Index);
                jo(length(jo) + 1) = jPlus;
                jo = sort(jo);
                
                jz = setdiff(jz, Teta0Index);
                
                delta(j0) = delta(j0) + Teta0*sigm;
                
                navigateToFourthStep = true;
            else
                %d
                jo = setdiff(jo, Teta0Index);
                jo(length(jo) + 1) = j0;
                jo = sort(jo);
                
                jz = setdiff(jz, Teta0Index);
                jz(length(jz) + 1) = j0;
                jz = sort(jz);
                
                navigateToFourthStep = false;
            end
        end
    end
end
end

function [x, jb] = GenerateBasisPlan(A, b)
[m, n] = size(A);
lz = find(b < 0);
A(lz, :) = -A(lz, :);
b(lz) = -b(lz);

ce = -[zeros(n, 1); ones(m, 1)];
Ae = [A eye(m)];
initx = [zeros(n, 1); b];
% TODO: catch exception
[x, jb] = simplex(ce, Ae, b, initx);

% Analyze result
assert(all(x(n+1:end) < eps), 'Task has no solution');
x = x(1:n);
end