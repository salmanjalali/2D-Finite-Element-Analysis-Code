%*************************************************************************
% MTE 204: Numerical Methods - Project 1B
% Group Number:     12

% Group Members:    Salman Jalali, Nathaniel Schmitz, Tai Sun, Aditya Boppe
%                   Srushti Rana
%*************************************************************************

clc;
close all;
clear all;

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

% % %  This chunk of code was used initially to create the appropriate
% % %  files for all the questions, this was a one time thing.
% generate_input_files();

% % % **********************************************
% % % Step One: Input Information, determine DOF, and initialize
% % % **********************************************

% % % UNCOMMENT FOR QUESTION1
[NODES,SCTR,PROPS,NODAL_BCS,NODAL_FORCES] = open_files(...
               'nodes1.txt',...
               'sctr1.txt',...
               'props1.txt',...
               'nodeBCs1.txt',...
               'nodeFORCES1.txt');

% % % UNCOMMENT FOR QUESTION2
% [NODES,SCTR,PROPS,NODAL_BCS,NODAL_FORCES] = open_files(...
%     'nodes2.txt',...
%     'sctr2.txt',...
%     'props2.txt',...
%     'nodeBCs2.txt',...
%     'nodeFORCES2.txt');

% [NODES,SCTR,PROPS,NODAL_BCS,NODAL_FORCES] = open_files(...
%     'nodes3.txt',...
%     'sctr3.txt',...
%     'props3.txt',...
%     'nodeBCs3.txt',...
%     'nodeFORCES3.txt');

% % % These values can be updated accordingly to work with different
% % % questions
OPTION = [
    1; % Time Steps
    5; % End Time: Set to 0.5 for question 3
    1; % Mode: 1 For Explicit Dynamcis and 2 For Implicit Dynamics
    3/2; % Gamma
    8/5; % Beta
    0; % Solve using Gauss-Seidel
    0; % Distribute Mass: 1 for questions 2 and 3, 0 for question 1
];

% % % If doing question 2, update the variable to the following:
% % % 'input2/variable_forces_1.txt' IF the time step is set to 0.1
% % % 'input2/variable_forces_3.txt' IF the time step is set to 0.001
% % % 'input2/variable_forces_5.txt' IF the time step is set to 0.00001
% % % Set to '' if doing questions 1 and 3
FVAR = '';

% % % If doing question 3, update the variable to the following
% % % 'input3/variable_disp_01.txt' IF the time step is set to 0.1
% % % 'input3/variable_disp_1.txt' IF the time step is set to 0.001
% % % 'input3/variable_disp_10.txt' IF the time step is set to 0.00001
% % % Set to '' if doing questions 1 and 2
DVAR = '';

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
[MGLOBAL] = buildMGLOBAL(NODES,SCTR,DOF,AREA,DENSITY,MGLOBAL,FIXED,OPTION(7,1));
[CGLOBAL] = buildCGLOBAL(NODES,SCTR,DOF,DAMPING,CGLOBAL);

% % % **********************************************************
% % % Step 6: Solve for Displacements and Forces
% % % **********************************************************

[UGLOBAL_MATRIX,VGLOBAL_MATRIX,AGLOBAL_MATRIX] = solveMCKU(KGLOBAL,MGLOBAL,CGLOBAL,FGLOBAL,UGLOBAL,FIXED,FREE,OPTION,FVAR,DVAR);

% % % % **********************************************************
% % % % Step 7: Post Processing
% % % % **********************************************************

% % % OPTIONAL: Used to view the model
% LAST = size(UGLOBAL_MATRIX, 1);
% COLS = size(UGLOBAL_MATRIX, 2);
% 
% for i = 1:5:size(UGLOBAL_MATRIX,1)
%     postprocesser(1000*NODES(:,1),1000*NODES(:,2),SCTR',1000*transpose(UGLOBAL_MATRIX(i, 2:COLS)))   
%     plottitle = sprintf('Deformation of Structure at Time %f ms' ,UGLOBAL_MATRIX(i,1));
%     title(plottitle)
%     plottitle = sprintf('Deformation of Structure at inc %d',i);
%     saveas(2,plottitle,'png');
%     display(UGLOBAL_MATRIX(i,1));
%     clf(2);   
% end
% clc;
