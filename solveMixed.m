function [UGLOBAL,FGLOBAL] = solveMixed(KGLOBAL, UGLOBAL, FGLOBAL, KNOWN, FIXED, FREE, SOLVE_GAUSS_SEIDEL)

indexmat = zeros(size(FGLOBAL));
for ii = 1:size(indexmat, 1)
    indexmat(ii) = ii;
end

% Row swapping Known
UPPER_KNOWN = KNOWN(FIXED, :);
LOWER_KNOWN = KNOWN(FREE, :);
NEW_KNOWN = KNOWN;
NEW_KNOWN(1:size(UPPER_KNOWN, 1), :) = UPPER_KNOWN;
NEW_KNOWN(size(UPPER_KNOWN, 1)+1:size(KNOWN, 1), :) = LOWER_KNOWN;

% Row swapping K
UPPER_K = KGLOBAL(FIXED, :);
LOWER_K = KGLOBAL(FREE, :);
NEW_KGLOBAL = KGLOBAL;
NEW_KGLOBAL(1:size(UPPER_K, 1), :) = UPPER_K;
NEW_KGLOBAL(size(UPPER_K, 1)+1:size(KGLOBAL, 1), :) = LOWER_K;

% Row swapping F
UPPER_FORCE = FGLOBAL(FIXED, :);
LOWER_FORCE = FGLOBAL(FREE, :);
NEW_FGLOBAL = FGLOBAL;
NEW_FGLOBAL(1:size(UPPER_FORCE, 1), :) = UPPER_FORCE;
NEW_FGLOBAL(size(UPPER_FORCE, 1)+1:size(FGLOBAL, 1), :) = LOWER_FORCE;

% Row swapping U
UPPER_U = UGLOBAL(FIXED, :);
LOWER_U = UGLOBAL(FREE, :);
NEW_UGLOBAL = UGLOBAL;
NEW_UGLOBAL(1:size(UPPER_U, 1), :) = UPPER_U;
NEW_UGLOBAL(size(UPPER_U, 1)+1:size(UGLOBAL, 1), :) = LOWER_U;

% Swapping indexmat
UPPER_I = indexmat(FIXED, :);
LOWER_I = indexmat(FREE, :);
NEW_indexmat = indexmat;
NEW_indexmat(1:size(UPPER_I, 1), :) = UPPER_I;
NEW_indexmat(size(UPPER_I, 1)+1:size(indexmat, 1), :) = LOWER_I;

% Column Swapping K
NEW_KGLOBAL = transpose(NEW_KGLOBAL);
UPPER_K = NEW_KGLOBAL(FIXED, :);
LOWER_K = NEW_KGLOBAL(FREE, :);
NEW_KGLOBAL(1:size(UPPER_K, 1), :) = UPPER_K;
NEW_KGLOBAL(size(UPPER_K, 1)+1:size(NEW_KGLOBAL, 1), :) = LOWER_K;
NEW_KGLOBAL = transpose(NEW_KGLOBAL);

NEW_FGLOBAL = NEW_KNOWN + NEW_FGLOBAL;

N = size(NEW_KGLOBAL, 1);
M = size(FIXED, 1);
Ke = NEW_KGLOBAL(1:M, 1:M);
Kef = NEW_KGLOBAL(1:M, M+1:N);
Kfe = NEW_KGLOBAL(M+1:N, 1:M);
Kf = NEW_KGLOBAL(M+1:N, M+1:N);
Xe = NEW_UGLOBAL(1:M);
Xf = NEW_UGLOBAL(M+1:N);
Be = NEW_FGLOBAL(1:M);
Bf = NEW_FGLOBAL(M+1:N);

% % % Attempted to solve using Gauss Seidel but could not get logic working
% % % in time so inv() is still being used
if SOLVE_GAUSS_SEIDEL == 1
    TEMP = Bf - Kfe * Xe;
    x0 = zeros(size(Xf,1 ), 1);
    Xf = solveGaussSeidel(Kf, TEMP, x0);
else
    Xf = inv(Kf) * (Bf - Kfe * Xe);
end

Be = Ke * Xe + Kef * Xf;

UGLOBAL = [Xe;Xf];
FGLOBAL = [Be; Bf];

newFGLOBAL = zeros(size(FGLOBAL,1), 1);
newUGLOBAL = zeros(size(UGLOBAL,1), 1);

for ii = 1:size(FGLOBAL, 1)
    newFGLOBAL(NEW_indexmat(ii, 1)) = FGLOBAL(ii, 1);
end

for ii = 1:size(UGLOBAL, 1)
    newUGLOBAL(NEW_indexmat(ii, 1)) = UGLOBAL(ii, 1);
end

UGLOBAL = newUGLOBAL;
FGLOBAL = newFGLOBAL - KNOWN;

end
