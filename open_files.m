function [NODES,SCTR,PROPS,NODAL_BCS,NODAL_FORCES] = open_files(nodes,sctr,props,nodeBC,nodeFORCES)

% % % This function receives a list of five file names, reads the data, and
% % % returns them as arrays
% % %                    
% % % Node File: Format (x1, y1, ...) // Location of x-cor, y-cor, etc. of node #1
% % %                   (x2, y2, ...) // Location of x-cor, y-cor, etc. of node #2
% % %                   ( ...       )
% % %                   (xn, yn, ...) // Location of x-cor, y-cor, etc. of node #n

% % % SCTR File Format (E1_1, E1_2)  // First node of element #1, second node of element #1 
% % %                  (E2_1, E2_2)  // First node of element #2, second node of element #2 
% % %                  ( ...      )
% % %                  (Ee_1, Ee_2)  // First node of element #e, second node of element #e 

% % % PROPS File Format (A1, YOUNG1)  // Area, Elastic Modulus of Element #1 
% % %                   (A2, YOUNG2)  // Area, Elastic Modulus of Element #2 
% % %                   ( ...      )
% % %                   (Ae, YOUNGe)  // Area, Elastic Modulus of Element #e 

% % % NODAL_BCS,FORCES File Format (NODE#, DIRECTION, MAGNITUDE)
% % % These are the prescribed displacements
% % %     NODE#: Which node the BC applies to
% % %     DIRECTION == 1: X-direction
% % %     DIRECTION == 2: Y-direction
% % %     MAGNITUDE: Amount prescribed

NODES = load(nodes);
SCTR = load(sctr);
PROPS = load(props);
NODAL_BCS = load(nodeBC);
NODAL_FORCES = load(nodeFORCES);

return