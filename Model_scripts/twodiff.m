function [rw,numTypew,numTypev,numTypevQ,cellstypewgen,cellstypevgen,cellstypewCC,cellstypevCC,...
             cellstypewdiv,cellstypevdiv,xw,yw,xv,yv,xvQ,yvQ] = twodiff(k,rw,P1w,P2w,P3w,PQv,numTypew,numTypev,numTypevQ,...
             meanCCv,stdCCv,cellstypewgen,cellstypevgen,cellstypewCC,cellstypevCC,cellstypewdiv,cellstypevdiv,xw,yw,xv,yv,xvQ,yvQ,aQ,aD,Lx,Ly)

% Input:  Change w for either A, B, or C for mother and v for B or C for daughter

% Two Differentitation of type w  (decrease count of w by 1 and increase v by 2 per cell)
  indxp4 = find(rw > (P1w+P2w+P3w)& rw<1);    % Find which cells will divide this way
  if ~isempty(indxp4)
      lenv = numTypev;
      numTypew = numTypew - 1*length(indxp4); % decrease cell count for w by 1
      rw(indxp4) = [];
    % Check how many of the newly created type v cells go quiescent
      r1Q    = rand(1,length(indxp4));
      PQvt   = (1-aQ)/Lx*PQv.*xw(indxp4) + aQ*PQv;
      indxQ  = find(r1Q < PQvt');
      indxQ2 = r1Q >= PQvt';
      numTypevQ = numTypevQ + length(indxQ);
    % update positions
      xvQ(end+1:end+length(indxQ),1) = xw(indxp4(indxQ));
      yvQ(end+1:end+length(indxQ),1) = yw(indxp4(indxQ));
    % number to keep    
      keepv = cellstypewgen(indxp4(indxQ2));
    % increase cell count for v by 2 per cell minus the quiescent
      newlenv  = 2*(length(indxp4) - length(indxQ));
      numTypev = numTypev + newlenv;
      if lenv == 0
          cellstypevgen(1:newlenv,1) = repmat(keepv',1,2)  + 1; % Make them one generation above their mothers
          meanCCvt = (1-aD)/Ly*meanCCv.*[xw(indxp4(indxQ2));xw(indxp4(indxQ2))] + aD*meanCCv;
          cellstypevCC(1:newlenv,1) = abs(ceil(meanCCvt + stdCCv*randn(newlenv,1)))+ k + 1; % determine the length of their cell cycle
          cellstypevdiv(1:newlenv,1) = 0;       % New cells have divied zero times
      else
          cellstypevgen(lenv+1:lenv+newlenv,1) = repmat(keepv',1,2)  + 1; % Make them one generation above their mothers
          meanCCvt = (1-aD)/Ly*meanCCv.*[xw(indxp4(indxQ2));xw(indxp4(indxQ2))] + aD*meanCCv;
          cellstypevCC(lenv+1:lenv+newlenv,1) = abs(ceil(meanCCvt + stdCCv*randn(newlenv,1)))+ k + 1; % determine the length of their cell cycle
          cellstypevdiv(lenv+1:lenv+newlenv,1) = 0;     % New cells have divied zero times
      end
    % update positions
      xv(lenv+1:lenv+newlenv,1) = [xw(indxp4(indxQ2)); xw(indxp4(indxQ2))];
      yv(lenv+1:lenv+newlenv,1) = [yw(indxp4(indxQ2)); yw(indxp4(indxQ2))];  
    % Erase data for the mothers
      cellstypewgen(indxp4) = [];
      cellstypewdiv(indxp4) = [];
      cellstypewCC(indxp4)  = [];

    xw(indxp4) = [];     yw(indxp4) = [];  
  end
  clear indxp4 r1Q indxQ indxQ2 keepv % clear auxiliary variables