function [KGLOBAL] = buildKGLOBAL(NODES,SCTR,DOF,YOUNG,AREA,KGLOBAL)

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

S = zeros(N, 1); % The sin of elements.
C = zeros(N, 1); % The cos of the elements.

% Calculate the x and y element displacements.
for ii = 1:N
    D(ii, :) = NODES(SCTR(ii, 1), :) - NODES(SCTR(ii, 2), :);
end

% Calculate the lengths of each of the elements.
for ii = 1:N
    L(ii) = sqrt(sum(D(ii, :) .^ 2));
end

% Calculate the sin and cos of the element displacements.
for ii = 1:N
    C(ii) = D(ii, 1) / L(ii); % dx / L = cos().
    S(ii) = D(ii, 2) / L(ii); % dy / L = sin().
end

% Calculate the k-value for each of the elements.
PROPS = AREA .* YOUNG ./ L;

for el = 1:N
    a = C(el);
    b = S(el);
    a2 = a * a;
    b2 = b * b;
    ab = a * b;
    
    KLOCAL = PROPS(el) * [
        a2, ab, -a2, -ab;
        ab, b2, -ab, -b2;
        -a2, -ab, a2, ab;
        -ab, -b2, ab, b2;
    ];

    for ii = 1:2
        for jj = 1:2
            i1 = SCTR(el, ii);
            i2 = SCTR(el, jj);
            sr = (ii - 1) * 2 + 1; % Start row.
            sc = (jj - 1) * 2 + 1; % Start col.
            a = KLOCAL(sr:sr+1, sc:sc+1);
            
            sgr = (i1 - 1) * 2 + 1; % Start row global.
            sgc = (i2 - 1) * 2 + 1; % Start col global.
            KGLOBAL(sgr:sgr+1, sgc:sgc+1) = KGLOBAL(sgr:sgr+1, sgc:sgc+1) + a;
        end
    end
end

end