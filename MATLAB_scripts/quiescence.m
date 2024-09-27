function [cellstypeCC,cellstypegen,cellstypediv,numType,numTypeQ,xQ,yQ,x,y] = ...
          quiescence(cellstypeCC,cellstypegen,cellstypediv,numType,numTypeQ,PQ,xQ,yQ,x,y,Lx,a)
 
 % Quiescent changes in the x-direction, from 0 to Lx increases from
 % (1-a)PQ to PQ (note a=0, pQ is constant)
   if ~isempty(cellstypeCC)
       if (a>0)&&(a<=1)
           PQt = a*PQ*(x./Lx + 1/a - 1);
       elseif a==0
           PQt = PQ;
       else
           error('a should be between 0 and 1')
       end
       indxQ = find(rand(size(PQt)) < PQt);
       numTypeQ = numTypeQ+ length(indxQ);  % number of quiescent cells
       numType  = numType - length(indxQ);  % number of active cells

     % Erase data for the dead cells at this time step
       cellstypeCC(indxQ)  = [];               % cell cycle info
       cellstypegen(indxQ) = [];               % generation info
       cellstypediv(indxQ) = [];

     % Update positions
       xQ = [xQ; x(indxQ)];  yQ = [yQ; y(indxQ)];
       x(indxQ) = [];       y(indxQ) = [];
   end

