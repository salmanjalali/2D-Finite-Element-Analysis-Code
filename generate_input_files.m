function generate_input_files()

% fid = fopen('input2/variable_forces_3.txt','w');
% for ii = 0:0.001:5.0
%     fprintf(fid, '%6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f\n',...
%         ii, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ii, 0);
% end

% fid = fopen('input2/variable_forces.txt','w');
% for ii = 0:0.1:5.0
%     fprintf(fid, '%6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f\n',...
%         ii, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ii, 0);
% end

% fid = fopen('input2/variable_forces.txt','w');
% for ii = 0:0.00001:5.0
%     fprintf(fid, '%6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f\n',...
%         ii, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ii, 0);
% end

fid = fopen('input3/variable_disp_10.txt','w');
for ii = 0:0.001:0.5
    ANG_FREQUENCY = 10 * 1000;
    DISPLACEMENT = 0.05 * sin(ANG_FREQUENCY * ii);
    fprintf(fid, '%6.4f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f\n',...
        ii, 0, 0, 0, 0, 0, 0, 0, 0, 0, DISPLACEMENT);
end

end