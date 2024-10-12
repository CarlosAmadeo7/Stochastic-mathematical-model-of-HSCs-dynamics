function [rw,numTypew,numTypev,numTypevQ,cellstypewgen,cellstypevgen,cellstypewCC,cellstypevCC,...
            cellstypewdiv,cellstypevdiv,xw,yw,xv,yv,xvQ,yvQ] = onediff(k,rw,P1w,P2w,P3w,PQv,meanCCv,stdCCv,...
            numTypew,numTypev,numTypevQ,cellstypewgen,cellstypevgen,cellstypewCC,...
            cellstypevCC,cellstypewdiv,cellstypevdiv,xw,yw,xv,yv,xvQ,yvQ,aQ,aD,Lx,Ly)

% Input:  Change w for either A, B, or C for mother and v for B or C for daughter

% One Differentitation of type w (decrease count of w by 1 and increase v by 1 per cell)
  indxp3 = find(rw > (P1w+P2w)& rw<(P1w+P2w+P3w));    % Find which cells will divide this way
  if ~isempty(indxp3)
      lenv      = numTypev;
      lenminusw = length(indxp3);
      numTypew  = numTypew - lenminusw;          % decrease cell count for w by 1
      rw(indxp3) = [];
      
    % Check how many of the newly created type v cells go quiescent
      r1Q    = rand(1,lenminusw);
      PQvt   = (1-aQ)/Lx*PQv.*xw(indxp3) + aQ*PQv;
      indxQ  = find(r1Q < PQvt');
      indxQ2 = r1Q >= PQvt';
      numTypevQ = numTypevQ + length(indxQ);
    % update positions
      xvQ(end+1:end+length(indxQ),1) = xw(indxp3(indxQ));
      yvQ(end+1:end+length(indxQ),1) = yw(indxp3(indxQ));
    % number to keep  
      keepv = cellstypewgen(indxp3(indxQ2));
    % increase cell count for v by 1 per cell minus the quiescent
      newlenv  = lenminusw - length(indxQ);
      numTypev = numTypev + newlenv;
    % update positions
      xv(end+1:end+newlenv,1) = xw(indxp3(indxQ2));
      yv(end+1:end+newlenv,1) = yw(indxp3(indxQ2));
      if lenv == 0
          cellstypevgen(1:newlenv,1) = keepv' + 1;      % Make them one generation above their mothers
          meanCCvt = (1-aD)/Ly*meanCCv.*xw(indxp3(indxQ2)) + aD*meanCCv;
          cellstypevCC(1:newlenv,1) = abs(ceil(meanCCvt + stdCCv*randn(newlenv,1)))+ k + 1; % determine the length of their cell cycle
          cellstypevdiv(1:newlenv,1) = 0;               % New cells have divied zero times
      else
          cellstypevgen(lenv+1:lenv+newlenv,1) = keepv' + 1; % Make them one generation above their mothers
          meanCCvt = (1-aD)/Ly*meanCCv.*xw(indxp3(indxQ2)) + aD*meanCCv;
          cellstypevCC(lenv+1:lenv+newlenv,1) = abs(ceil(meanCCvt + stdCCv*randn(newlenv,1)))+ k + 1; % determine the length of their cell cycle
          cellstypevdiv(lenv+1:lenv+newlenv,1) = 0;      % New cells have divied zero times
      end
      % Erase data for the mothers
      cellstypewgen(indxp3) = [];
      cellstypewdiv(indxp3) = [];
      cellstypewCC(indxp3)  = [];


    xw(indxp3) = [];     yw(indxp3) = [];  
  end
  clear indxp3 r1Q indxQ indxQ2 keepv;                 % clear auxiliary variables
