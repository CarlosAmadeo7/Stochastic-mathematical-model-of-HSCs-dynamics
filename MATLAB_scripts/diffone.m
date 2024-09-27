function [r,numType1,numType2,cellstypegen1,cellstypegen2,cellstypeCC1,...
           cellstypeCC2,cellstypediv1,cellstypediv2,x1,y1,x2,y2] = ...
           diffone(r,P1,P2,P3,numType1,numType2,cellstypegen1,cellstypegen2,...
           cellstypeCC1,cellstypeCC2,cellstypediv1,cellstypediv2,x1,y1,x2,y2,meanCC2,stdCC2,k,Ly,a1)

%% One Differentitation of type 1 (decrease count of 1 by 1 and increase 2 by 1 per cell)
        indxp3 = find(r > (P1+P2)& r<(P1+P2+P3));    % Find which cells will divide this way
        if ~isempty(indxp3)
            len2      = numType2;
            lenminus1 = length(indxp3);
            numType1  = numType1 - lenminus1;       % decrease cell count for type 1 by 1

          % Place the new cells at the same position as their "mothers"
            x2(len2+1:len2+lenminus1,1) = [x1(indxp3)];
            y2(len2+1:len2+lenminus1,1) = [y1(indxp3)];
            
            r(indxp3) = [];                         % update random vector
            x1(indxp3) = [];    y1(indxp3) = [];    % Update position vector
          
          % increase cell count for type 2 by 1 per cell
            numType2 = numType2 + lenminus1;
            if len2 == 0
              % Make them one generation above their mothers  
                cellstypegen2(1:lenminus1) = cellstypegen1(indxp3) + 1;      
              % Determine the length of their cell cycle
                if (a1>0)&&(a1<=1)
                    meanCCt2 = a1*meanCC2*(y2(1:lenminus1)./Ly + 1/a1 - 1);
                elseif a1==0
                    meanCCt2 = meanCC2;
                else
                    error('a1 should be between 0 and 1')
                end
                cellstypeCC2(1:lenminus1) = abs(ceil(meanCCt2 + stdCC2*randn(lenminus1,1))) + k + 1;
              % New cells have divied zero times  
                cellstypediv2(1:lenminus1) = 0;               
            else
              % Make them one generation above their mothers   
                cellstypegen2(len2+1:len2+lenminus1) = cellstypegen1(indxp3) + 1;
              % Determine the length of their cell cycle  
                if (a1>0)&&(a1<=1)
                    meanCCt2 = a1*meanCC2*(y2(len2+1:len2+lenminus1)./Ly + 1/a1 - 1);
                elseif a1==0
                    meanCCt2 = meanCC2;
                else
                    error('a1 should be between 0 and 1')
                end
                cellstypeCC2(len2+1:len2+lenminus1) = abs(ceil(meanCCt2 + stdCC2*randn(lenminus1,1))) + k + 1;
              % New cells have divied zero times
                cellstypediv2(len2+1:len2+lenminus1) = 0;      
            end

          % Erase data for the mothers
            cellstypegen1(indxp3) = [];
            cellstypediv1(indxp3) = [];
            cellstypeCC1(indxp3)  = [];
        end
