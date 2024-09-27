function [numTypeQ] = apopQuies(numTypeQ,PAQ)    

% Quiescent cells
      rAd       = rand(1,numTypeQ);            % random number 
      indxd1    = find(rAd < PAQ);             % compare with probability of quiescence
      numTypeAQ = numTypeQ - length(indxd1);   % reduce number of cells
