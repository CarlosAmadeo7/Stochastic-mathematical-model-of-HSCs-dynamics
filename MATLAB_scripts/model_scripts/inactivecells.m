function [numTypew,numTypewI,cellstypewCC,cellstypewgen,cellstypewdiv,xw,yw,xIw,yIw] = ...
           inactivecells(cellstypewdiv,max_divisions_w,numTypew,numTypewI,...
                          cellstypewCC,cellstypewgen,xw,yw,xIw,yIw)

% For the input, change the w in the names for A, B, or C

% Check which cells had divided enough times -> stop dividing and become innactive

   %%%%%%%%%%%% Type A cells %%%%%%%%%%%%
   indxd1 = find(cellstypewdiv > max_divisions_w);
   if ~isempty(indxd1)
       numTypew  = numTypew - length(indxd1);   % reduce number of active cells
       numTypewI = numTypewI + length(indxd1);  % increase number of inactive cells
     % Erase their data from the active pool
       cellstypewCC(indxd1)  = [];              % cell cycle info
       cellstypewgen(indxd1) = [];              % generation info
       cellstypewdiv(indxd1) = [];              % # of divisions info

     % Update positions  
       xIw = [xIw; xw(indxd1)]; yIw = [yIw; yw(indxd1)];
       xw(indxd1) = [];  yw(indxd1) = [];       

   end
   clear indxd1
