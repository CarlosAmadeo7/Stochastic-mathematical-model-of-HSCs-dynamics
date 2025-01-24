function plotdensity(xy,numcells,frame)

% xy are the coordinates for the given parameter.  For example, if
% plotting active A cells, it should be xyA.
% numcells is the number of cells, in the example above numTypeA
% Frame is the time step you want to plot

% After running the main code:
% >> [cellstypeA, cellstypeB, cellstypeC, params] = cellmodel_diff_spaQD();
% The coordinates are extracted as
% >> xyA = cellstypeA.xyA; For active
% >> xyAQ = cellstypeA.xyAQ; For quiescent
% >> xyAI = cellstypeA.xyAI; For inactive
% For B and C cells, change the A for B and C.
% Similarly, for numcells
% numcellsA = cellstypeA.Num;
% numcellsAQ = cellstypeA.NumQ;
% numcellsAI = cellstypeA.NumI;

figure
Nc = sum(numcells);
xyp = xy{frame}; 
H   = hist3(xyp./Nc);
contourf(flip(H'),100,'LineStyle','none')



