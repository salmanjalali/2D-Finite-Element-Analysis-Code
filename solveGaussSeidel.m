function [xk] = solveGaussSeidel(A, b, x0)
    n = size(A, 1);     % The size of [A].
    prev = x0;          % (k) values.
    curr = x0;          % (k+1) values.
    error = inf;        % Exit when error < threshold.
    iter = 0;           % Iteration number.
    
    while error >= 0.000000000000000001
        for ii = 1:n
            summation = b(ii, 1);
            for jj = 1:ii-1
                summation = summation - A(ii, jj) * curr(jj);
            end
            for jj = ii+1:n
                summation = summation - A(ii, jj) * prev(jj);
            end
            curr(ii, 1) = summation / A(1, 1);
        end
        
        error = max(abs(prev - curr));
        iter = iter + 1;
        prev = curr;
    end
    xk = curr;
end

