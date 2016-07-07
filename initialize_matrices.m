function [KGLOBAL,FGLOBAL,UGLOBAL,MGLOBAL,CGLOBAL] = initialize_matrices(DOF,N)

% % % This function receives the degree of freedom and number of nodes.
% % % The function returns an initialized Kglobal, Fglobal, and Uglobal
% % % matrix.

% Initialize all of the matrices to a value of 0. This step's objective is
% to properly size the matrices. Building the values within will not be
% performed in this step.
FGLOBAL = zeros(DOF * N, 1);
UGLOBAL = zeros(DOF * N, 1);
KGLOBAL = zeros(DOF * N, DOF * N);
CGLOBAL = zeros(DOF * N, DOF * N);
MGLOBAL = zeros(DOF * N, DOF * N);

end