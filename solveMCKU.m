function [UGLOBAL_MATRIX, VGLOBAL_MATRIX, AGLOBAL_MATRIX] = solveMCKU(KGLOBAL,MGLOBAL,CGLOBAL,FGLOBAL,UGLOBAL,FIXED,FREE,OPTION,FVAR,DVAR)

N = size(UGLOBAL,1);

% Initialize the matrices
CURRENT_FGLOBAL = FGLOBAL;
CURRENT_DISP = UGLOBAL;
PREV_DISP = UGLOBAL;
CURRENT_VEL = zeros(N, 1);
CURRENT_ACC = zeros(N, 1);

dT = OPTION(1, 1);
EdT = OPTION(2, 1);
MODE = OPTION(3, 1);
SOLVE_GAUSS_SEIDEL = OPTION(5, 1);
dT2 = dT^2;

GAMMA = OPTION(4, 1);
BETA = OPTION(5, 1);

IMATRIX = 0:dT:EdT;
UGLOBAL_MATRIX = zeros(size(IMATRIX, 2), 1 + N);
VGLOBAL_MATRIX = zeros(size(IMATRIX, 2), 1 + N);
AGLOBAL_MATRIX = zeros(size(IMATRIX, 2), 1 + N);

if length(FVAR) > 0
   VARIABLE_FORCES = dlmread(FVAR);
end

if length(DVAR) > 0
    VARIABLE_DISPLACEMENTS = dlmread(DVAR);
end

index = 1;

if MODE == 1
    tic
    A = ((1/dT2) * MGLOBAL + (1/(2 * dT)) * CGLOBAL);
    B = (KGLOBAL - (2/dT2) * MGLOBAL);
    D = ((1/dT2)*(MGLOBAL) - (1/(2 * dT)) * CGLOBAL);
    for ii = 0:dT:EdT
        if exist('VARIABLE_FORCES','var')
            CURRENT_FGLOBAL(21, 1) = VARIABLE_FORCES(index, 22);
        end
        if exist('VARIABLE_DISPLACEMENTS','var')
            CURRENT_DISP(10, 1) = VARIABLE_DISPLACEMENTS(index, 11);
        end
        
        KNOWN = -1 * (B * CURRENT_DISP + D * PREV_DISP);
        [NEXT_DISP, NEXT_FGLOBAL] = solveMixed(A, CURRENT_DISP, CURRENT_FGLOBAL, KNOWN, FIXED, FREE, SOLVE_GAUSS_SEIDEL);
        
        CURRENT_VEL = (1/(2*dT)) * (NEXT_DISP - PREV_DISP);
        CURRENT_ACC = (1/dT2) * (NEXT_DISP - 2 * CURRENT_DISP + PREV_DISP);
        
        UGLOBAL_MATRIX(index, 1) = ii;
        UGLOBAL_MATRIX(index, 2:1+N) = CURRENT_DISP';
        VGLOBAL_MATRIX(index, 1) = ii;
        VGLOBAL_MATRIX(index, 2:1+N) = CURRENT_VEL';
        
        AGLOBAL_MATRIX(index, 1) = ii;
        AGLOBAL_MATRIX(index, 2:1+N) = CURRENT_ACC';
        
        PREV_DISP = CURRENT_DISP;
        CURRENT_FGLOBAL = NEXT_FGLOBAL;
        CURRENT_DISP = NEXT_DISP;
        
        index = index + 1;
    end
    Explicit_Dynamics_Time = toc;
    display(Explicit_Dynamics_Time);
else
    tic
    Atilda = (2/(BETA * dT2))*MGLOBAL + KGLOBAL + ((2 * GAMMA)/(BETA * dT)) * CGLOBAL;
    Btilda = (2/(BETA * dT2))*MGLOBAL + ((2 * GAMMA)/(BETA * dT)) * CGLOBAL;
    Ctilda = (2/(BETA * dT))*MGLOBAL + (2*GAMMA/BETA - 1) * CGLOBAL;
    Dtilda = ((1 - BETA)/BETA) * MGLOBAL + (dT * ((GAMMA - 1) + (1 - BETA) * GAMMA / BETA)) * CGLOBAL;
    
    for ii = 0:dT:EdT
        if exist('VARIABLE_FORCES','var')
            CURRENT_FGLOBAL(21, 1) = VARIABLE_FORCES(index, 22);
        end
        if exist('VARIABLE_DISPLACEMENTS','var')
            CURRENT_DISP(10, 1) = VARIABLE_DISPLACEMENTS(index, 11);
        end
        
        % I think we need to remove that node from free/fixed. I dont even
        % think the FREE and FIXED are generated correctly for this
        % question.
        KNOWN = Btilda * CURRENT_DISP + Ctilda * CURRENT_VEL + Dtilda * CURRENT_ACC;
        [NEXT_DISP, NEXT_FGLOBAL] = solveMixed(Atilda, CURRENT_DISP, CURRENT_FGLOBAL, KNOWN, FIXED, FREE, SOLVE_GAUSS_SEIDEL);
        
        NEXT_ACC = (2/(BETA * dT))* (1/dT)*(NEXT_DISP - CURRENT_DISP) - (2/(BETA*dT)) * CURRENT_VEL - ((1 - BETA)/BETA) * CURRENT_ACC;
        NEXT_VEL = dT * ((1-GAMMA) * CURRENT_ACC + GAMMA * NEXT_ACC) + CURRENT_VEL;
        
        UGLOBAL_MATRIX(index, 1) = ii;
        UGLOBAL_MATRIX(index, 2:1+N) = CURRENT_DISP';
        VGLOBAL_MATRIX(index, 1) = ii;
        VGLOBAL_MATRIX(index, 2:1+N) = CURRENT_VEL';
        AGLOBAL_MATRIX(index, 1) = ii;
        AGLOBAL_MATRIX(index, 2:1+N) = CURRENT_ACC';
        
        CURRENT_DISP = NEXT_DISP;
        CURRENT_ACC = NEXT_ACC;
        CURRENT_VEL = NEXT_VEL;
        CURRENT_FGLOBAL = NEXT_FGLOBAL;
        
        index = index + 1;
    end
    Implicit_Dynamics_Time = toc;
    display(Implicit_Dynamics_Time);
end
end