function [numTypew,numTypewQ,cellstypewCC,cellstypewgen,cellstypewdiv,xw,yw,xwQ,ywQ] = ...
           apoptosis(numTypew,numTypewQ,PAw,PAQw,...
                     cellstypewCC,cellstypewgen,cellstypewdiv,xw,yw,xwQ,ywQ)

% Determine which cells die in this time step

    % Death of Active cells
      if numTypew ~=0 
          rAd      = rand(1,numTypew);              % random number
          indxd1   = find(rAd < PAw);               % compare with probability of apoptosis
          numTypew = numTypew - length(indxd1);     % reduce number of cells
        % Erase data for the dead cells at this time step
          cellstypewCC(indxd1)  = [];               % cell cycle info
          cellstypewgen(indxd1) = [];               % generation info
          cellstypewdiv(indxd1) = [];               % # of divisions info
        % Update positions  
          xw(indxd1)  = []; yw(indxd1) = [];

          clear indxd1 rAd;                         % clear auxiliary variables
      end

    % Death of Quiescent cells
      if numTypewQ ~= 0
          rAd       = rand(1,numTypewQ);            % random number
          indxd1    = find(rAd < PAQw);             % compare with probability of apoptosis
          numTypewQ = numTypewQ - length(indxd1);   % reduce number of cells

        % Update positions  
          xwQ(indxd1) = []; ywQ(indxd1) = [];
          clear indxd1 rAd;  % clear auxiliary variables
      end

