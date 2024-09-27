function [xA, yA, xAQ, yAQ, xAI, yAI, xB, yB, xBQ, yBQ, xBI, yBI, xC, yC,...
          numTypeAQ, numTypeA, numTypeAI, numTypeB,numTypeBI, ...
          numTypeBQ, numTypeC, cellstypeA, cellstypeB,...
          cellstypeC] = initializevars(Nc,Lx,Ly,PQA,meanCCA,stdCCA,a)

% Initial positions
   x0 = Lx.*rand(Nc,1);    y0 = Ly.*rand(Nc,1);
 
  % Initial number of typeA quiescent 

    % Quiescent changes in the x-direction, from 0 to Lx increases from
    % (1-a)PQA to PQA (note a=0, pQA is constant)
    if (a>0)&&(a<=1)
        PQAt = a*PQA*(x0./Lx + 1/a - 1);
    elseif a==0
        PQAt = PQA;
    else
        error('a should be between 0 and 1')
    end
    indxQ = find(rand(size(PQAt)) < PQAt);
    numTypeAQ = length(indxQ);      % number of quiescent cells type A
    numTypeA  = Nc - length(indxQ); % number of active cells type A

    xA  = x0; xA(indxQ)=[];  yA  = y0;  yA(indxQ)=[];
    xAQ = x0(indxQ);   yAQ = y0(indxQ);


    xB = [];   yB= [];  xBQ = []; yBQ = [];


    % plot density
    % xy = [x0A, y0A];
    % H=hist3(xy./Nc);
    % contourf(flip(H'),'LineStyle','none')

  % Set other counters 
    numTypeAI = 0;      % number of innactive cells type A
    numTypeB  = 0;      % number of active cells type B
    numTypeBI = 0;      % number of innactive cells type B
    numTypeBQ = 0;      % number of quiescent cells type B
    numTypeC  = 0;      % number of active cells type C
   

  % Store counters in the output variables   
    cellstypeA.Num(1)  = numTypeA;
    cellstypeB.Num(1)  = numTypeB;
    cellstypeA.NumQ(1) = numTypeAQ;
    cellstypeB.NumQ(1) = numTypeBQ;
    cellstypeA.NumI(1) = numTypeAI;
    cellstypeB.NumI(1) = numTypeBI;
    cellstypeC.Num(1)  = numTypeC;

% Set cell cylcle length for cells 
  a1 = 0.95;
  if (a1>0)&&(a1<=1)
        meanCCAt = a1*meanCCA*(yA./Ly + 1/a1 - 1); 
    elseif a1==0
        meanCCAt = meanCCA;
    else
        error('a1 should be between 0 and 1')
  end
  cellstypeA.CC{1} = abs(ceil(meanCCAt + stdCCA*randn(numTypeA,1)));
  cellstypeB.CC{1} = [];
  cellstypeC.CC{1} = [];

% Counter to keep track of the generation for each cell  
  cellstypeA.gen{1} = ones(numTypeA,1);
  cellstypeB.gen{1} = [];
  cellstypeC.gen{1} = [];

% Counter to keep track of how many divisions each cell has gone through  
  cellstypeA.div{1} = zeros(numTypeA,1);
  cellstypeB.div{1} = [];
  cellstypeC.div{1} = [];

% Save positions
  cellstypeA.xyA{1}  = [xA,yA];
  cellstypeA.xyAQ{1} = [xAQ,yAQ];
  cellstypeB.xyB{1}  = [];
  cellstypeB.xyBQ{1} = [];
  cellstypeC.xyC{1}  = [];


% Positions of innactive cells
  xAI = [];  yAI = [];
  xBI = [];  yBI = [];
  xC  = [];  yC  = [];