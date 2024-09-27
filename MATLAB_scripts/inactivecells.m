function [cellstypeCC,cellstypegen,cellstypediv,x,y,xI,yI,numType,numTypeI] = inactivecells(...
             max_divisions,cellstypediv,numType,numTypeI,cellstypeCC,cellstypegen,...
             x,y,xI,yI)

indxd1 = find(cellstypediv > max_divisions);
   if ~isempty(indxd1)
       numType  = numType - length(indxd1);   % reduce number of active cells
       numTypeI = numTypeI + length(indxd1);  % increase number of inactive cells
     % Erase their data from the active pool
       cellstypeCC(indxd1)  = [];              % cell cycle info
       cellstypegen(indxd1) = [];              % generation info
       cellstypediv(indxd1) = [];              % # of divisions info
     % Update positions
       xI = [xI x(indxd1)];  yI = [yI y(indxd1)]; 
       x(indxd1) = [];         y(indxd1) = []; 
   end
   clear indxd1

