function [MGLOBAL] = buildMGLOBAL(NODES,SCTR,DOF,AREA,DENSITY,MGLOBAL,FIXED)

% % % This function receives the node list, the elemental connectivity
% matrix, degree of freedom of the problem, elastic modulus, area and an
% empty Kglobal matrix.

% % % This function builds the transformed local elemental matrix and
% % % inserts it into the global stiffness matrix.

% % % At the end of the function, the fully assembled Kglobal matrix is
% % % returned.

N = size(SCTR, 1); % The number of elements.
L = zeros(N, 1); % The length of each of the elements.
D = zeros(N, DOF); % The length of the element broken up into x and y.

% Calculate the x and y element displacements.
for ii = 1:N
    D(ii, :) = NODES(SCTR(ii, 1), :) - NODES(SCTR(ii, 2), :);
end

% Calculate the lengths of each of the elements.
for ii = 1:N
    L(ii) = sqrt(sum(D(ii, :) .^ 2));
end

VOL = AREA .* L;
MASS = VOL .* DENSITY;

for el = 1:N
    START = SCTR(el, 1);
    END = SCTR(el, 2);

    MASS_START = zeros(DOF, DOF);
    if ismember(START, FIXED) == 1
        MASS_START = (MASS(el) / 2) * eye(DOF);
    end

    MASS_END = zeros(DOF, DOF);
    if ismember(END, FIXED) == 1
        MASS_END = (MASS(el) / 2) * eye(DOF);
    end
    
    START_GLOBAL = (START - 1) * 2 + 1; % Start diagonal global.
    END_GLOBAL = (END - 1) * 2 + 1; % End diagonal global.

    MGLOBAL(START_GLOBAL:START_GLOBAL+1, START_GLOBAL:START_GLOBAL+1) = MGLOBAL(START_GLOBAL:START_GLOBAL+1, START_GLOBAL:START_GLOBAL+1) + MASS_START;
    MGLOBAL(END_GLOBAL:END_GLOBAL+1, END_GLOBAL:END_GLOBAL+1) = MGLOBAL(END_GLOBAL:END_GLOBAL+1, END_GLOBAL:END_GLOBAL+1) + MASS_END;
end
end