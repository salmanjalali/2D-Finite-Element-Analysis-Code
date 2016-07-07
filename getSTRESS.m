function [STRESS] = getSTRESS(SCTR,NODES,YOUNG,DOF,UGLOBAL)
% % % This function returns the stress in a spring/bar element
% % % This function receives the elemental connectivity matrix, nodal
% % % locations, elastic modulus, degree of freedom, and solved global
% % % displacements vector.

% % % This function returns an array/vector that contains the elemental
% % % stress information for each element.

N = size(SCTR, 1); % The number of elements.
L = zeros(N, 1); % The length of each of the elements.
% D = zeros(N, DOF); % The length of the element broken up into x and y.

% S = zeros(N, 1); % The sin of elements.
% C = zeros(N, 1); % The cos of the elements.

% Calculate the x and y element displacements.
for ii = 1:N
    node1 = SCTR(ii, 1);
    node2 = SCTR(ii, 2);
    D(ii, :) = NODES(node1, :) - NODES(node2, :);
end

% Calculate the lengths of each of the elements.
for ii = 1:N
    L(ii) = sqrt(sum(D(ii, :) .^ 2));
end

STRESS = zeros(N, 1);

for ii = 1:N
    node1 = SCTR(ii, 1);
    node2 = SCTR(ii, 2);
    index1 = (node1 - 1) * 2;
    index2 = (node2 - 1) * 2;
    node1Pos = NODES(node1);
    node2Pos = NODES(node2);
    node1Disp = [UGLOBAL(index1 + 1, :), UGLOBAL(index1 + 2, :)];
    node2Disp = [UGLOBAL(index2 + 1, :), UGLOBAL(index2 + 2, :)];
    
    start = node1Pos + node1Disp;
    ending = node2Pos + node2Disp;
    
    displacement = start - ending;
       
    length = sqrt(sum(displacement .^ 2));    
    STRESS(ii) = (YOUNG(ii) * (length - L(ii))) / L(ii);
end

% Calculate the sin and cos of the element displacements.
% % % % % % % % for ii = 1:N
% % % % % % % %     C(ii) = D(ii, 1) / L(ii); % dx / L = cos().
% % % % % % % %     S(ii) = D(ii, 2) / L(ii); % dy / L = sin().
% % % % % % % % end
% % % % % % % % 
% % % % % % % % for el = 1:N
% % % % % % % %     a = C(el);
% % % % % % % %     b = S(el);
% % % % % % % %     
% % % % % % % %     T = [
% % % % % % % %         a, b, 0, 0;
% % % % % % % %         -b, a, 0, 0;
% % % % % % % %         0, 0, a, b;
% % % % % % % %         0, 0, -b, a;
% % % % % % % %     ];
% % % % % % % %     
% % % % % % % %     node1 = SCTR(el, 1);
% % % % % % % %     node2 = SCTR(el, 2);
% % % % % % % %     index1 = (node1 - 1) * 2;
% % % % % % % %     index2 = (node2 - 1) * 2;
% % % % % % % %     ULOCAL = zeros(4, 1);
% % % % % % % %     ULOCAL(1, 1) = UGLOBAL(index1 + 1, 1);
% % % % % % % %     ULOCAL(2, 1) = UGLOBAL(index1 + 2, 1);
% % % % % % % %     ULOCAL(3, 1) = UGLOBAL(index2 + 1, 1);
% % % % % % % %     ULOCAL(4, 1) = UGLOBAL(index2 + 2, 1);
% % % % % % % %     
% % % % % % % % %     display(T);
% % % % % % % % %     display(ULOCAL);
% % % % % % % % %     display(T * ULOCAL);
% % % % % % % %     
% % % % % % % %     sigma = (YOUNG(el) / L(el)) * T * ULOCAL;
% % % % % % % %     display(sigma);
% % % % % % % % end
% % % % % % % % 


end