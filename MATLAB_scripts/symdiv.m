function [r,numType,x,y,cellstypegen,cellstypeCC,cellstypediv] = ...
           symdiv(r,P1,numType,x,y,cellstypegen,cellstypeCC,...
                  cellstypediv,meanCC,stdCC,k,Ly,a1)

%% Symmetric division (increase count by 2 per cell)
   indxp1   = find(r < P1);          % Find which cells will divide this way
   if ~isempty(indxp1)
       len    = numType;             % Current number of cells
       lennew =  2*length(indxp1);    % 2 times the number of cell dividing
     % Place the new cells at the same position as their "mothers"
       x(len+1:len+lennew,1) = [x(indxp1); x(indxp1)];
       y(len+1:len+lennew,1) = [y(indxp1); y(indxp1)];
     % increase cell count by 2
       numType = len + lennew;
     % set random vector for new cells
       r(len+1:len+lennew) = 1;
     % Make the new cells one generation above than their "mothers"
       cellstypegen(len+1:len+lennew) = repmat(cellstypegen(indxp1),1,2) + 1;
     % Determine the length of the cell cycle for the new cells
       if (a1>0)&&(a1<=1)
           meanCCt = zeros(length(len+1:len+lennew),1);
           meanCCt(:,1) = a1*meanCC*(y(len+1:len+lennew)./Ly + 1/a1 - 1);
       elseif a1==0
           meanCCt = meanCC;
       else
           error('a1 should be between 0 and 1')
       end
       cellstypeCC(len+1:len+lennew) = abs(ceil(meanCCt + stdCC*randn(lennew,1))) + k + 1;
     % Update the length of the cell cycle for the mothers so they can divide again
       cellstypeCC(indxp1) = cellstypeCC(indxp1) + k + 1;
     % Update the counter of the cells for the number of times the have divided
       cellstypediv(indxp1) =  cellstypediv(indxp1) + 1;
     % New cells have divided zero times
       cellstypediv(len+1:len+lennew) = 0;
   end
   

