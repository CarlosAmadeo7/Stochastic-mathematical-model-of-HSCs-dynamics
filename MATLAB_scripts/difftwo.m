function [numType1,numType2,cellstypegen1,cellstypegen2,...
           cellstypeCC1,cellstypeCC2,cellstypediv1,cellstypediv2,x1,y1,x2,y2,meanCC2,stdCC2,k,Ly] = ...
           difftwo(r,P1,P2,P3,numType1,numType2,cellstypegen1,cellstypegen2,...
           cellstypeCC1,cellstypeCC2,cellstypediv1,cellstypediv2,x1,y1,x2,y2,meanCC2,stdCC2,k,Ly,a1)


%% Two Differentitation of type 1  (decrease count of 1 by 1 and increase 2 by 2 per cell)

indxp4 = find(r > (P1+P2+P3)& r<1);    % Find which cells will divide this way
        if ~isempty(indxp4)
            len2 = numType2;
            len2new = length(indxp4);
            numType1 = numType1 - len2new; % decrease cell count for 1 by 1

          % Place the new cells at the same position as their "mothers"
            x2(len2+1:len2+2*len2new,1) = [x1(indxp4); x1(indxp4)];
            y2(len2+1:len2+2*len2new,1) = [y1(indxp4); y1(indxp4)];

            x1(indxp4) = [];    y1(indxp4) = [];    % Update position vector

          % increase cell count for 2 by 2 per cell 
            newlen2  = 2*len2new;
            numType2 = numType2 + newlen2;
            if len2 == 0
              % Make them one generation above their mothers  
                cellstypegen2(1:newlen2) = repmat(cellstypegen1(indxp4),1,2)  + 1; 
              % Determine the length of their cell cycle
                if (a1>0)&&(a1<=1)
                    meanCCt2 = a1*meanCC2*(y2(1:newlen2)./Ly + 1/a1 - 1);
                elseif a1==0
                    meanCCt2 = meanCC2;
                else
                    error('a1 should be between 0 and 1')
                end
                cellstypeCC2(1:newlen2)  = abs(ceil(meanCCt2 + stdCC2*randn(newlenB,1)))+ k + 1; %%%%%%% I change the newlenB for newlen2
              % New cells have divied zero times
                cellstypediv2(1:newlen2) = 0;       
            else
              % Make them one generation above their mothers  
                cellstypegen2(len2+1:len2+newlen2) = repmat(cellstypegen1(indxp4),1,2)  + 1; 
              % Determine the length of their cell cycle
                if (a1>0)&&(a1<=1)
                    meanCCt2 = a1*meanCC2*(y2(1:newlen2)./Ly + 1/a1 - 1);
                elseif a1==0
                    meanCCt2 = meanCC2;
                else
                    error('a1 should be between 0 and 1')
                end
                cellstypeCC2(len2+1:len2+newlen2)  = abs(ceil(meanCCt2 + stdCC2*randn(newlen2,1)))+ k + 1; 
              % New cells have divied zero times
                cellstypediv2(len2+1:len2+newlen2) = 0;  
            end
          % Erase data for the mothers
            cellstypegen1(indxp4) = [];
            cellstypediv1(indxp4) = [];
            cellstypeCC1(indxp4)  = [];
        end
        