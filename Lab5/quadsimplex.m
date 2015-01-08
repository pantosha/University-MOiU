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
assert(all((A*x) == b), 'Не выполняются основные ограничения');
assert(all((x) >= 0), 'Не выполняются прямые ограничения');

skipFirstPhase = false;
while (true)
    if (~skipFirstPhase)
        jnz = setdiff(1:n, jz);
        
        % Шаг 1
        cx = c + D*x;
        u = -cx(jo)'/A(:, jo); % потенциалы
        % TODO: считать deltas только jnz (deltas = (u*A(:, jnz))' + cx(jnz))
        deltas = (u*A)' + cx; % оценки
        
        % Шаг 2. Проверка на оптимальность
        if all(deltas(jnz) >= 0)
            fval = c'*x + 0.5*x'*D*x;
            return;
        end
        
        % Шаг 3. Находим минимальный индекс отрицательного элемента из jnz,
        % j0 - индекс в jnz
        j0 = min(jnz(deltas(jnz) < 0));
    end
    
    % Шаг 4. Формируем систему
    % Dz*lz + Az'*y + Dzj0 = 0
    % Az*lz +Aj0 = 0
    
    %       /Dz | Az'\
    % Hz = | -- + --- |
    %       \Az | 0  /
    Dz = D(jz, jz);
    Az = A(:, jz);
    Hz = [Dz, Az'; Az, zeros(m)];
    
    Dzj0 = D(jz, j0);
    Aj0 = A(:, j0);
    hj0 = [Dzj0; Aj0];
    
    %                 /lz\
    % -Hz^-1 * hj0 = | -- |
    %                 \ y/
    tmp = -Hz\hj0;
    l = tmp(1:length(jz));
    y = tmp(length(jz)+1:end);
    
    % gamma = l'Dl = Dzj0'*lz + Aj0'*y + dj0j0
    gamma = Dzj0'*l + Aj0'*y + D(j0, j0);
    
    lz = l < 0;
    jlz = jz(lz);
    [teta, iteta] = min(-x(jlz)./l(lz));
    iteta = jlz(iteta);
    
    newTeta = abs(deltas(j0)/gamma);
    if newTeta < teta
        teta = newTeta;
        iteta = j0;
    end
    
    if ~isfinite(teta)
        disp('Целевая функция неограничена снизу.');
        return;
    end
    
    % Шаг 5. Постройка нового плана
    xj0 = x(j0);
    x(jnz) = 0;
    x(jz) = x(jz) + teta.*l;
    x(j0) = xj0 + teta;
    
    % Шаг 6.
    if iteta == j0
        %a
        jz(end + 1) = j0;
        skipFirstPhase = false;
    elseif any(setdiff(jz, jo) == iteta)
        %b
        jz = setdiff(jz, iteta);
        deltas(j0) = deltas(j0) + teta*gamma;
        skipFirstPhase = true;
    else
        js = iteta;
        asteriskWithoutSupport = setdiff(jz, jo);
        
        jPlus = 0;
        for j=1:length(asteriskWithoutSupport)
            es = zeros(length(jo), 1);
            es(jo == js) = 1;
            
            bufferResultWithJPlus = es'/A(:, jo)*A(:, asteriskWithoutSupport(j));
            
            if (bufferResultWithJPlus ~= 0)
                jPlus = asteriskWithoutSupport(j);
                break;
            end
        end
        
        if jPlus ~= 0
            %c
            jo = setdiff(jo, iteta);
            jo(end + 1) = jPlus;
            
            jz = setdiff(jz, iteta);
            deltas(j0) = deltas(j0) + teta*gamma;
            
            skipFirstPhase = true;
        else
            %d
            jo = setdiff(jo, iteta);
            jo(end + 1) = j0;
            
            jz = setdiff(jz, iteta);
            jz(end + 1) = j0;
            
            skipFirstPhase = false;
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