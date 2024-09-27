function [r,numType1,numType2,x1,y1,x2,y2,cellstypegen1,cellstypeCC1,cellstypediv1,...
           cellstypegen2,cellstypeCC2,cellstypediv2] = asymdiv(r,P1,P2,...
           numType1,numType2,x1,y1,x2,y2,cellstypegen1,cellstypeCC1,cellstypediv1,...
           cellstypegen2,cellstypeCC2,cellstypediv2,meanCC1,stdCC1,meanCC2,stdCC2,k,Ly,a1)

%% Asymmetric (increase count of type 1 by 1 and type 2 by 1 per cell)
   indxp2 = find(r > P1 & r < (P1+P2)); % Find which cells will divide this way
   if ~isempty(indxp2)
       len1     = numType1;
       len2     = numType2;
       len12new = length(indxp2);
     % Place the new cells at the same position as their "mothers"
       x1(len1+1:len1+len12new,1) = [x1(indxp2)];
       y1(len1+1:len1+len12new,1) = [y1(indxp2)];
       x2(len2+1:len2+len12new,1) = [x1(indxp2)];
       y2(len2+1:len2+len12new,1) = [y1(indxp2)];
     % increase cell count for type 1 by 1 for each cell
       numType1 = len1 + len12new;
     % Update random vector  
       r(len1+1:len1+len12new) = 1;
     % increase cell count for 2 by 1 
       numType2 = len2 + len12new;  
     % Make them one generation above their mothers
       cellstypegen1(len1+1:len1+len12new) = cellstypegen1(indxp2)+1;
       if isempty(cellstypegen2)
           cellstypegen2(1:len12new) = 1;
       else
           cellstypegen2(len2+1:len2+len12new) = cellstypegen1(indxp2)+1;
       end
     % Determine the length of their cell cycle
       if (a1>0)&&(a1<=1)
           meanCCt1 = a1*meanCC1*(y1(len1+1:len1+len12new)./Ly + 1/a1 - 1);
           meanCCt2 = a1*meanCC2*(y2(len2+1:len2+len12new)./Ly + 1/a1 - 1);
       elseif a1==0
           meanCCt1 = meanCC1;
           meanCCt2 = meanCC2;
       else
           error('a1 should be between 0 and 1')
       end
       cellstypeCC1(len1+1:len1+len12new) = abs(ceil(meanCCt1 + stdCC1*randn(len12new,1))) + k + 1;
       cellstypeCC2(len2+1:len2+len12new) = abs(ceil(meanCCt2 + stdCC2*randn(len12new,1))) + k + 1;
     % Update mothers' length of cell cyle
       cellstypeCC1(indxp2) = cellstypeCC1(indxp2) + k + 1;
     % Update number of divisions for the mothers
       cellstypediv1(indxp2) = cellstypediv1(indxp2) + 1;
     % New cells have divied zero times
       cellstypediv1(len1+1:len1+len12new) = 0;
       cellstypediv2(len2+1:len2+len12new) = 0;
   end