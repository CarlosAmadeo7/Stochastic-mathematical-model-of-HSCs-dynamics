function [rw,numTypew,numTypev,numTypevQ,cellstypewgen,cellstypevgen,cellstypewCC,...
            cellstypevCC,cellstypewdiv,cellstypevdiv,xw,yw,xv,yv,xvQ,yvQ] = asymdiv(k,rw,P1w,P2w,PQv,...
            numTypew,numTypev,numTypevQ,meanCCw,meanCCv,stdCCw,stdCCv,...
            cellstypewgen,cellstypevgen,cellstypewCC,cellstypevCC,...
            cellstypewdiv,cellstypevdiv,xw,yw,xv,yv,xvQ,yvQ,aQ,aD,Lx,Ly)

% Input:  Change w for either A, B, or C for mother and v for v or C for daughter

% Asymmetric of type w (increase count of type w by 1 and v by 1 per cell)

   indxp2 = find(rw > P1w & rw<(P1w+P2w)); % Find which cells will divide this way
   if ~isempty(indxp2)
       lenw     = numTypew;
       lenv     = numTypev;
       lenwvnew = length(indxp2);
     % increase cell count for w by 1 for each cell
       numTypew = lenw + lenwvnew;
       rw(end+1:end+lenwvnew) = 1;
     % Check how many of the v cells go quiescent
       r1Q    = rand(1,lenwvnew);
       PQvt   = (1-aQ)/Lx*PQv.*xw(indxp2) + aQ*PQv;
       indxQ  = find(r1Q < PQvt');
       indxQ2 = r1Q >= PQvt';
       numTypevQ = numTypevQ + length(indxQ);
     % update positions
       xvQ(end+1:end+length(indxQ),1) = xw(indxp2(indxQ));
       yvQ(end+1:end+length(indxQ),1) = yw(indxp2(indxQ));
     % How many stay  
       keepv = cellstypewgen(indxp2(indxQ2));
     % increase cell count for v by 1 per cell minus the quiescent
       newlenv  = lenwvnew - length(indxQ);
       numTypev = numTypev + newlenv;
     % update positions
       xv(end+1:end+newlenv,1) = xw(indxp2(indxQ2));
       yv(end+1:end+newlenv,1) = yw(indxp2(indxQ2));  
     % update positions type w
       xw(end+1:end+lenwvnew,1) = xw(indxp2);
       yw(end+1:end+lenwvnew,1) = yw(indxp2);  
     % Make them one generation above their mothers
       cellstypewgen(lenw+1:lenw+lenwvnew,1) = cellstypewgen(indxp2)+1;
       cellstypevgen(lenv+1:lenv+newlenv,1) = keepv'+1;
     % Determine the length of their cell cycle
       meanCCwt   = (1-aD)/Ly*meanCCw.*xw(indxp2) + aD*meanCCw;
       cellstypewCC(lenw+1:lenw+lenwvnew,1) = abs(ceil(meanCCwt + stdCCw*randn(lenwvnew,1)))+ k + 1;
       meanCCvt   = (1-aD)/Ly*meanCCv.*xw(indxp2(indxQ2)) + aD*meanCCv;
       cellstypevCC(lenv+1:lenv+newlenv,1)  = abs(ceil(meanCCvt + stdCCv*randn(newlenv,1)))+ k + 1;
     % Update mothers' length of cell cyle
       cellstypewCC(indxp2,1) = cellstypewCC(indxp2) + k + 1;
     % Update number of divisions for the mothers
       cellstypewdiv(indxp2,1) = cellstypewdiv(indxp2) + 1;
     % New cells have divied zero times
       cellstypewdiv(lenw+1:lenw+lenwvnew,1) = 0;
       cellstypevdiv(lenv+1:lenv+newlenv,1)  = 0;
   end
   clear indxp2 r1Q indxQ indxQ2 keepv;    % clear auxiliary variables