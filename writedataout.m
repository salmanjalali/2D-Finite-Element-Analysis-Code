function writedataout(filename,NODES,SCTR,DOF,UGLOBAL,FGLOBAL,STRESS)
% % % This function outputs a file a containing all the information
% % % required as presented in the DEMO submission file.

% % % This function also determines what stress state a member is under.

fid = fopen(filename,'wt');
fprintf(fid, 'MTE 204 - Project 1a Submission Document\n');
fprintf(fid, 'Group #12\n');
name1 = 'Nathaniel Schmitz';
name2 = 'Salman Jalali';
name3 = 'Tai Sun';
name4 = 'Srushti Rana';
name5 = 'Aditya Boppe';

id1 = '20572373';
id2 = '20569951';
id3 = '20569636';
id4 = '20502378';
id5 = '20589368';

Fa = 2230;
Fb = 930;
Fc = 340;
Fd = -2700;

fprintf(fid, 'Name Student 1: %20s   ID: %8s\n', name1, id1);
fprintf(fid, 'Name Student 2: %20s   ID: %8s\n', name2, id2);
fprintf(fid, 'Name Student 3: %20s   ID: %8s\n', name3, id3);
fprintf(fid, 'Name Student 4: %20s   ID: %8s\n', name4, id4);
fprintf(fid, 'Name Student 5: %20s   ID: %8s\n', name5, id5);

fprintf(fid, '\n');

fprintf(fid, '///************************************************************\n');
fprintf(fid, 'SOLUTIONS TO GROUP #12 PROBLEM 1a - 2016\n');
fprintf(fid, '///************************************************************\n');

fprintf(fid, '/// Calculated Forces (N)\n');
fprintf(fid, 'Fa = %16.10f, Fb = %16.10f\n', Fa, Fb);
fprintf(fid, 'Fc = %16.10f, Fd = %16.10f\n', Fc, Fd);

fprintf(fid, '\n');

fprintf(fid, '/// Nodal Positions (mm)\n');
for ii = 1:size(NODES,1)
    node = ii;
    index = (node - 1) * 2;
    nodexPos = UGLOBAL(index + 1);
    nodeyPos = UGLOBAL(index + 2);
    fprintf(fid, 'U%.2dx = %14.10f, U%.2dy = %14.10f\n',ii, nodexPos, ii, nodeyPos);
end

fprintf(fid, '\n');

fprintf(fid, '/// Nodal Forces (N)\n');
for ii = 1:size(NODES,1)
    node = ii;
    index = (node - 1) * 2;
    nodexForce = FGLOBAL(index + 1);
    nodeyForce = FGLOBAL(index + 2);
    fprintf(fid, 'F%.2dx = %16.10f, F%.2dy = %16.10f\n',ii, nodexForce, ii, nodeyForce);
end

fprintf(fid, '\n');

fprintf(fid, '/// Element Stresses\n');
fprintf(fid, '/// ID, Node 1, Node 2, STRESS[MPa]\n');
fprintf(fid,'---------------------------------------------------------------\n');

for ii = 1:size(SCTR,1)
  fprintf(fid, '%2.0f, %2.0f, %2.0f, %13.10f', ii, SCTR(ii,1), SCTR(ii,2), STRESS(ii) );
  if (STRESS(ii)<0)
    fprintf(fid, ' [%11s]\n','COMPRESSION');
  else
    fprintf(fid, ' [%7s]\n','TENSION');
  end
end





fclose(fid);
end
