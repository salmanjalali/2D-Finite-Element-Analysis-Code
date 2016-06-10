%*************************************************************************
% MTE 204: Numerical Methods
% Header: Christopher Kohar, University of Waterloo, Spring 2016
%*************************************************************************

clc;
close all;
clear all;

% generate_input_files();

% % % **********************************************
% % % THE CORE FINITE ELEMENT STEPS
% % % **********************************************
% % % 1)	Model discretization  How to break up the problem into smaller manageable problems
% % % 2)	Interpolation  How to represent behaviour between two points (in this case, we will start with linear assumptions)
% % % 3)	Element properties   Apply our physics and mathematical models of motion
% % % 4)	Element assembly How to take the small individual elements to construct the phenomenon we are trying to model
% % % 5)	Boundary conditions and constrains
% % % 6)	Solve our equations of motion to determine displacement, deformation, voltage, current, temperature, etc.
% % % 7)	Post processing

% % % **********************************************
% % % Step One: Input Information, determine DOF, and initialize
% % % **********************************************
% % % UNCOMMENT FOR QUESTION1
% [NODES,SCTR,PROPS,NODAL_BCS,NODAL_FORCES] = open_files(...
%                'nodes1.txt',...
%                'sctr1.txt',...
%                'props1.txt',...
%                'nodeBCs1.txt',...
%                'nodeFORCES1.txt');

% % % UNCOMMENT FOR QUESTION2
% [NODES,SCTR,PROPS,NODAL_BCS,NODAL_FORCES] = open_files(...
%     'nodes2.txt',...
%     'sctr2.txt',...
%     'props2.txt',...
%     'nodeBCs2.txt',...
%     'nodeFORCES2.txt');

[NODES,SCTR,PROPS,NODAL_BCS,NODAL_FORCES] = open_files(...
    'nodes3.txt',...
    'sctr3.txt',...
    'props3.txt',...
    'nodeBCs3.txt',...
    'nodeFORCES3.txt');

[DOF] = get_DOF(NODES);
[KGLOBAL,FGLOBAL,UGLOBAL,MGLOBAL,CGLOBAL] = initialize_matrices(DOF,size(NODES,1));

% % % *******************************************************
% % % Step Three: PROCESS MATERIAL INFORMATION
% % % *******************************************************
[AREA,YOUNG,DENSITY,DAMPING] = process_material_props(PROPS);

% % % ******************************************************
% % % Step Four: Matrix Assembly
% % % ******************************************************
[KGLOBAL] = buildKGLOBAL(NODES,SCTR,DOF,YOUNG,AREA,KGLOBAL);

% % % ******************************************************
% % % Step Five: Boundary Conditions
% % % ******************************************************
[UGLOBAL,FIXED] = buildNODEBCs(UGLOBAL,NODAL_BCS,DOF);
[FGLOBAL,FREE] = buildFORCEBCs(FGLOBAL,NODAL_FORCES,FIXED,DOF,size(KGLOBAL,1));
[MGLOBAL] = buildMGLOBAL(NODES,SCTR,DOF,AREA,DENSITY,MGLOBAL,FIXED);
[CGLOBAL] = buildCGLOBAL(NODES,SCTR,DOF,DAMPING,CGLOBAL);

% % % **********************************************************
% % % Step 6: Solve for Displacements and Forces
% % % **********************************************************

OPTION = [
    0.001; % Time Steps
    0.5; % End Time
    2; % Mode: 1 For Explicit Dynamcis and 2 For Implicit Dynamics
    3/2; % Gamma
    8/5; % Beta
];

FVAR = '';
DVAR = 'input3/variable_disp_10.txt';

[UGLOBAL_MATRIX,VGLOBAL_MATRIX,AGLOBAL_MATRIX] = solveMCKU(KGLOBAL,MGLOBAL,CGLOBAL,FGLOBAL,UGLOBAL,FIXED,FREE,OPTION,FVAR,DVAR);

% % % % **********************************************************
% % % % Step 7: Post Processing
% % % % **********************************************************

% LAST = size(UGLOBAL_MATRIX, 1);
% COLS = size(UGLOBAL_MATRIX, 2);
% postprocesser(NODES(:, 1), NODES(:, 2), SCTR, transpose(UGLOBAL_MATRIX(LAST, 2:COLS)));

