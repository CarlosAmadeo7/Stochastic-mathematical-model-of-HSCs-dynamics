function [numType,cellstypeCC,cellstypegen,cellstypediv,x,y] =...
            apoptosis(numType,PAA,cellstypeCC,cellstypegen,cellstypediv,x,y)

  rAd      = rand(1,numType);              % random number 
  indxd1   = find(rAd < PAA);              % compare with probability of apoptosis
  numType  = numType - length(indxd1);     % reduce number of cells

% Erase data for the dead cells at this time step
  cellstypeCC(indxd1)  = [];               % cell cycle info
  cellstypegen(indxd1) = [];               % generation info
  cellstypediv(indxd1) = [];               % # of divisions info

% Update positions
  x(indxd1) = [];         y(indxd1) = [];

