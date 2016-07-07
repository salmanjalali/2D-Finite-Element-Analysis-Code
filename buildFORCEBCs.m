function [FGLOBAL,FREE] = buildFORCEBCs(FGLOBAL,NODAL_FORCES,FIXED,DOF,N)

% % % This function receives the initialized global force matrix,
% % % list of nodes that have applied force, list nodal boundary conditions
% % % indices, degree of freedom and number of equations required to be solved.

% % % This function creates a vector (called FREE) that corresponds to the
% % % list of indices of the force vector [Fglobal] that are known.
% % % I.e. If F3y,F4x,F10y are known forces for a 2D problem, 
% % % the vector would contain the indices FREE = [6,7,20]
% % % 
% % % If a node was not prescribed in either displacements or force 
% % % boundary conditions, then it is assumed to be a free node with an
% % % applied load of 0.
% % %
% % % This function updates and returns the global force vector with the known
% % % perscribed boundary force condition.  The function also returns the vector
% % % of indices of known forces. 

MAX = size(FGLOBAL, 1);
VALUES = linspace(1, MAX, MAX);
FREE = setdiff(VALUES, FIXED)';

N = size(NODAL_FORCES, 1);
for ii = 1:N
    node = NODAL_FORCES(ii, 1);
    coord = NODAL_FORCES(ii, 2);
    index = (node - 1) * 2 + coord;
    FGLOBAL(index, 1) = NODAL_FORCES(ii, 3);
end

end