function [AREA, YOUNG, DENSITY, DAMPING] = process_material_props(PROPS)
% % % This function receives the material properties matrix
% % % This function partitions and returns the area and elastic modulus

AREA = PROPS(:, 2);
YOUNG = PROPS(:, 1);
DENSITY = PROPS(:, 3);
DAMPING = PROPS(:, 4);

end