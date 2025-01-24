function [numTypeAQ,numTypeA,numTypeAI,numTypeB,numTypeBI,numTypeBQ,numTypeC,numTypeCQ,...
    cellstypeA,cellstypeB,cellstypeC,xA,yA,xAQ,yAQ,xAI,yAI,xB,yB,xBQ,yBQ,xBI,yBI,...
    xC,yC,xCQ,yCQ,xCI,yCI] = initializevars(NA,NB,Lx,Ly,PQA,meanCCA,stdCCA,meanCCB,stdCCB,aQ,aD)

% Initial positions
  xA = Lx.*rand(NA,1);    yA = Ly.*rand(NA,1);
  xB = Lx.*rand(NB,1);    yB = Ly.*rand(NB,1);
  xC = [];                yC = [];

% Initial number of typeA quiescent 
  PQAt = (1-aQ)/Lx*PQA.*xA + aQ*PQA;
  indxQ = find(rand(1,NA) < PQAt');
  numTypeAQ = length(indxQ);      % number of quiescent cells type A
  numTypeA  = NA - length(indxQ); % number of active cells type A

% Initial position of quiescent
  xAQ = xA(indxQ);   yAQ = yA(indxQ);
  xBQ = [];          yBQ = []; 
  xCQ = [];          yCQ = []; 

% Remove positions from xA and yA  
  xA(indxQ) = [];    yA(indxQ) = [];

% Positions of innactive cells
  xAI = [];  yAI = [];
  xBI = [];  yBI = [];
  xCI = [];  yCI = [];   

% Set other counters 
  numTypeAI = 0;      % number of innactive cells type A
  numTypeB  = NB;     % number of active cells type B
  numTypeBI = 0;      % number of innactive cells type B
  numTypeBQ = 0;      % number of quiescent cells type B
  numTypeC  = 0;      % number of active cells type C
  numTypeCI = 0;      % number of innactive cells type C
  numTypeCQ = 0;      % number of quiescent cells type C


% Store counters in the output variables   
  cellstypeA.Num(1)  = numTypeA;
  cellstypeB.Num(1)  = numTypeB;
  cellstypeC.Num(1)  = numTypeC;
  cellstypeA.NumQ(1) = numTypeAQ;
  cellstypeB.NumQ(1) = numTypeBQ;
  cellstypeC.NumQ(1) = numTypeCQ;
  cellstypeA.NumI(1) = numTypeAI;
  cellstypeB.NumI(1) = numTypeBI;
  cellstypeC.NumI(1) = numTypeCI;


% Set cell cylcle length for cells 
  meanCCAt   = (1-aD)/Ly*meanCCA.*xA + aD*meanCCA;
  cellstypeA.CC{1} = abs(ceil(meanCCAt + stdCCA*randn(numTypeA,1)));
  meanCCBt   = (1-aD)/Ly*meanCCB.*xB + aD*meanCCB;
  cellstypeB.CC{1} = abs(ceil(meanCCBt + stdCCB*randn(numTypeB,1)));
  cellstypeC.CC{1} = [];

% Counter to keep track of the generation for each cell  
  cellstypeA.gen{1} = ones(numTypeA,1);
  cellstypeB.gen{1} = ones(numTypeB,1);
  cellstypeC.gen{1} = [];

% Counter to keep track of how many divisions each cell has gone through  
  cellstypeA.div{1} = zeros(numTypeA,1);
  cellstypeB.div{1} = zeros(numTypeB,1);
  cellstypeC.div{1} = [];

% Save positions
  cellstypeA.xyA{1}  = [xA,yA];
  cellstypeA.xyAQ{1} = [xAQ,yAQ];
  cellstypeA.xyAI{1} = [xAI,yAI];
  cellstypeB.xyB{1}  = [xB,yB];
  cellstypeB.xyBQ{1} = [xBQ,yBQ];
  cellstypeB.xyBI{1} = [xBI,yBI];
  cellstypeC.xyC{1}  = [xC,yC];
  cellstypeC.xyCQ{1} = [xCQ,yCQ];
  cellstypeC.xyCI{1} = [xCI,yCI];

 
