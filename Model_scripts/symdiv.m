function [rw,numTypew,cellstypewgen,cellstypewCC,cellstypewdiv,xw,yw] = ...
          symdiv(k,rw,P1w,numTypew,meanCCw,stdCCw,...
                 cellstypewgen,cellstypewCC,cellstypewdiv,xw,yw,aQ,aD,Lx,Ly)

% Input:  Change w for either A, B, or C

% Symmetric division of type w (increase count of type w by 2 per cell)
   
  indxp1   = find(rw < P1w);          % Find which cells will divide this way
  if ~isempty(indxp1)
      lenw    = numTypew;             % Current number of type w
      lenwnew =  2*length(indxp1);    % 2 times the number of cell dividing
    % increase cell count by 2
      numTypew = lenw + lenwnew;
      rw(end+1:end+lenwnew) = 1;
    % update positions
      xw(lenw+1:lenw+lenwnew,1) = [xw(indxp1); xw(indxp1)];
      yw(lenw+1:lenw+lenwnew,1) = [yw(indxp1); yw(indxp1)];
    % Make the new cells one generation above than their "mothers"
      cellstypewgen(lenw+1:lenw+lenwnew,1) = repmat(cellstypewgen(indxp1,1),2,1) + 1;
    % Determine the length of the cell cycle for the new cells
      meanCCwt   = (1-aD)/Ly*meanCCw.*[xw(indxp1);xw(indxp1)] + aD*meanCCw;
      cellstypewCC(lenw+1:lenw+lenwnew,1) = abs(ceil(meanCCwt + stdCCw*randn(lenwnew,1))) + k + 1;
    % Update the length of the cell cycle for the mothers so they can divide again
      cellstypewCC(indxp1,1) = cellstypewCC(indxp1) + k + 1;
    % Update the counter of the cells for the number of times the have divided
      cellstypewdiv(indxp1,1) =  cellstypewdiv(indxp1) + 1;
    % New cells have divided zero times
      cellstypewdiv(lenw+1:lenw+lenwnew,1) = 0;
  end
  clear indxp1;                       % clear auxiliary variables
