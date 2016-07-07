%*************************************************************************
% 2D Truss (Chapter 2)        
% Original version by                                                
% Dr. Haim Waisman, Columbia University, New York, Copyright 2009    
% Modified 2012,2013                                                      
% Dr. Robert Gracie, University of Waterloo, Waterloo, 
% Modified 2014
% Christopher Kohar, University of Waterloo
%*************************************************************************
% Postprocessing function 
function postprocesser(x,y,sctr,d) % % % Pass in the x-coordinate, y-coordinate, element connectivity, nodal displacement vector
% scale the displacements
du = d;

% plot the deformed shape of the truss
nel = size(sctr,2); % number of elements

figure(2);
for i = 1:nel

    % PLOT INITIAL DEFORMED STRUCTURE
    XXI = [x(sctr(1,i)) x(sctr(2,i))];
    YYI = [y(sctr(1,i)) y(sctr(2,i))];
    line(XXI,YYI,'LineWidth',2);hold on;

    % PLOT FINAL DEFORMED STRUCTURE
    XXF = [(x(sctr(1,i))+du(2*sctr(1,i)-1)) (x(sctr(2,i))+du(2*sctr(2,i)-1)) ];
    YYF = [(y(sctr(1,i))+du(2*sctr(1,i)))   (y(sctr(2,i))+du(2*sctr(2,i)))];
    line(XXF,YYF,'LineWidth',2,'Color','RED','LineStyle','--');hold on;
    legend('Undeformed','Deformed','Location','SouthWest');
    % Initial Node Location Labels
    text(XXI(1),YYI(1),sprintf('%0.5g',sctr(1,i)));
    text(XXI(2),YYI(2),sprintf('%0.5g',sctr(2,i)));
    % Final Node Location Labels
    text(XXF(1),YYF(1),sprintf('%0.5g',sctr(1,i)));
    text(XXF(2),YYF(2),sprintf('%0.5g',sctr(2,i)));
end
hold off;

axis( [0,600,-100, 600])
xlabel('X-Position [mm]');
ylabel('Y-Position [mm]');

grid on;


end
    
