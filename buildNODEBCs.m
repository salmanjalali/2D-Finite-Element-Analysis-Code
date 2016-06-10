function [UGLOBAL,FIXED] = buildNODEBCs(UGLOBAL,NODAL_BCS,DOF)

% % % This function receives the initialized global displacements matrix,
% % % list of nodal boundary conditions,and degree of freedom.

% % % This function creates a vector (called FIXED) that corresponds to the
% % % list of indices of the displacement vector [Uglobal] that are known.
% % % I.e. If U3y,U4x,U10y are known displacements for a 2D problem,
% % % the vector would contain the indices FIXED = [6,7,20]
% % %

% % % This function updates and returns the global displacement vector with the known
% % % perscribed boundary condition.  The function also returns the vector
% % % of indices of known displacements

N = size(NODAL_BCS, 1);
FIXED = zeros(N, 1);

for ii = 1:N
    node = NODAL_BCS(ii, 1);
    coord = NODAL_BCS(ii, 2);
    index = (node - 1) * 2 + coord;
    
    FIXED(ii, 1) = index;
    UGLOBAL(index, 1) = NODAL_BCS(ii, 3);
end

end
