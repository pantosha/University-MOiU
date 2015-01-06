function out = GetLoopElements( plan )
    m = size(plan, 1);
    n = size(plan, 2);
    skippedRows = [];
    skippedColumns = [];
    
    while (true)
        skippedDimensions = 0;
        
        for i=1:m
            if (~any(skippedRows == i))
                pointsCount = 0;
                
                for j=1:n
                    if (~any(skippedColumns == j))
                        if (plan(i, j) ~= 0)
                            pointsCount = pointsCount + 1;
                        end
                    end
                end
                
                if (pointsCount < 2)
                    skippedRows(length(skippedRows) + 1) = i;
                    skippedDimensions = skippedDimensions + 1;
                    break;
                end
            end
        end
        
        
        for j=1:n
            if (~any(skippedColumns == j))
                pointsCount = 0;
                
                for i=1:m
                    if (~(any(skippedRows == i)))
                        if (plan(i, j) ~= 0)
                            pointsCount = pointsCount + 1;
                        end
                    end
                end
                
                if (pointsCount < 2)
                    skippedColumns(length(skippedColumns) + 1) = j;
                    skippedDimensions = skippedDimensions + 1;
                    break;
                end
            end
        end
        
        if (skippedDimensions == 0)
            break;
        end
    end
    
    out = zeros(m, n);
    for i=1:m
        if (~any(skippedRows == i))
            for j=1:n
                if (~any(skippedColumns == j) && (plan(i, j) == 1))
                    out(i, j) = 1;
                end
            end
        end
    end
end

