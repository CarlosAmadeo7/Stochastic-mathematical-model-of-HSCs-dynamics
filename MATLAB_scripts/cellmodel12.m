function [cellstypeA, cellstypeB, cellstypeC, params] = cellmodel12(varargin) %Accepting any kind of variable 

%% Last updated September 8, 2024

% Parsing the input parameters
p = inputParser;
addParameter(p, 'PQA', 0.5);
addParameter(p, 'PQB', 0.5);
addParameter(p, 'P1A', 0.4);
addParameter(p, 'P2A', 0.1);
addParameter(p, 'P3A', 0.25);
addParameter(p, 'P4A', 0.25);
addParameter(p, 'P1B', 0.25);
addParameter(p, 'P2B', 0.25);
addParameter(p, 'P3B', 0.25);
addParameter(p, 'P4B', 0.25);
addParameter(p, 'PAA', 0.056);
addParameter(p, 'PAB', 0.00);
addParameter(p, 'PAQA', 0.01)
addParameter(p, 'PAQB', 0.01)
addParameter(p, 'meanCCA', 1);
addParameter(p, 'stdCCA', 1.5);
addParameter(p, 'meanCCB', 1);
addParameter(p, 'stdCCB', 0.5);
addParameter(p, 'max_divisions_A', 5);
addParameter(p, 'max_divisions_B', 5);
parse(p, varargin{:});

% Using parsed parameters
PQA = p.Results.PQA;
PQB = p.Results.PQB;
P1A = p.Results.P1A;
P2A = p.Results.P2A;
P3A = p.Results.P3A;
P4A = p.Results.P4A;
P1B = p.Results.P1B;
P2B = p.Results.P2B;
P3B = p.Results.P3B;
P4B = p.Results.P4B;
PAA = p.Results.PAA;
PAB = p.Results.PAB;
PAQA = p.Results.PAQA;
PAQB = p.Results.PAQB;
meanCCA = p.Results.meanCCA;
stdCCA = p.Results.stdCCA;
meanCCB = p.Results.meanCCB;
stdCCB = p.Results.stdCCB;
max_divisions_A = p.Results.max_divisions_A;
max_divisions_B = p.Results.max_divisions_B;

% Random seed
  seed = 123456789;
  rng(seed)

% Parameters
  Nc = 1e4;             % Initial number of cells
  Nt = 100;             % total number of time steps


% Initial conditions 
  % Initial number of typeA quiescent 
    indxQ = find(rand(1,Nc) > PQA);
    numTypeAQ = length(indxQ);      % number of quiescent cells type A
    numTypeA  = Nc - length(indxQ); % number of active cells type A

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
  cellstypeA.CC{1} = abs(ceil(meanCCA + stdCCA*randn(numTypeA,1)));
  cellstypeB.CC{1} = [];

% Counter to keep track of the generation for each cell  
  cellstypeA.gen{1} = ones(numTypeA,1);
  cellstypeB.gen{1} = [];
  cellstypeC.gen{1} = [];

% Counter to keep track of how many divisions each cell has gone through  
  cellstypeA.div{1} = zeros(numTypeA,1);
  cellstypeB.div{1} = [];

%% Begin time evolution
   for k = 1:Nt

   %% Temporary store data from previous step
      cellstypeACC  = cellstypeA.CC{k};
      cellstypeAgen = cellstypeA.gen{k};
      cellstypeAdiv = cellstypeA.div{k};
      cellstypeBCC  = cellstypeB.CC{k};
      cellstypeBgen = cellstypeB.gen{k};
      cellstypeBdiv = cellstypeB.div{k};
      cellstypeCgen = cellstypeC.gen{k};

   %% Inactive Cells
   % Check which cells had divided enough times -> stop dividing and become innactive

   %%%%%%%%%%%% Type A cells %%%%%%%%%%%%
   indxd1 = find(cellstypeAdiv > max_divisions_A);
   if ~isempty(indxd1)
       numTypeA  = numTypeA - length(indxd1);   % reduce number of active cells
       numTypeAI = numTypeAI + length(indxd1);  % increase number of inactive cells
     % Erase their data from the active pool
       cellstypeACC(indxd1)  = [];              % cell cycle info
       cellstypeAgen(indxd1) = [];              % generation info
       cellstypeAdiv(indxd1) = [];              % # of divisions info
   end
   clear indxd1

   %%%%%%%%%%%% Type B cells %%%%%%%%%%%%
   indxd1 = find(cellstypeBdiv > max_divisions_B);
   if ~isempty(indxd1)
       numTypeB  = numTypeB - length(indxd1);   % reduce number of active cells
       numTypeBI = numTypeBI + length(indxd1);  % increase number of inactive cells
     % Erase their data from the active pool
       cellstypeBCC(indxd1)  = [];              % cell cycle info
       cellstypeBgen(indxd1) = [];              % generation info
       cellstypeBdiv(indxd1) = [];              % # of divisions info
   end
   clear indxd1

 %% Apoptosis

  %%%%%%%%%%%% Type A cells %%%%%%%%%%%%
  % Determine which cells die in this time step

    % Active cells
      rAd      = rand(1,numTypeA);              % random number 
      indxd1   = find(rAd < PAA);               % compare with probability of apoptosis
      numTypeA = numTypeA - length(indxd1);     % reduce number of cells
    % Erase data for the dead cells at this time step
      cellstypeACC(indxd1)  = [];               % cell cycle info 
      cellstypeAgen(indxd1) = [];               % generation info
      cellstypeAdiv(indxd1) = [];               % # of divisions info
      clear indxd1 rAd;                         % clear auxiliary variables

    % Quiescent cells
      rAd       = rand(1,numTypeAQ);            % random number 
      indxd1    = find(rAd < PAQA);             % compare with probability of apoptosis
      numTypeAQ = numTypeAQ - length(indxd1);   % reduce number of cells
      clear indxd1 rAd;                         % clear auxiliary variables


   %%%%%%%%%%%% Type B cells %%%%%%%%%%%%
   % Determine which cells die in this time step

   % Active cells
     if numTypeB ~=0 
         rBd      = rand(1,numTypeB);           % random number 
         indxd2   = find(rBd < PAB);            % compare with probability of apoptosis
         numTypeB = numTypeB - length(indxd2);  % reduce number of cells
       % Erase data  
         cellstypeBCC(indxd2)  = [];            % cell cycle info 
         cellstypeBgen(indxd2) = [];            % generation info
         cellstypeBdiv(indxd2) = [];            % # of divisions info
         
         clear indxd2 rBd;                      % clear auxiliary variables
     end
     

   % Quiescent cells
     if numTypeBQ ~=0 
         rBd       = rand(1,numTypeBQ);        % random number
         indxd2    = find(rBd < PAQB);         % compare with probability of apoptosis
         numTypeBQ = numTypeBQ - length(indxd2); % reduce number of cells
         clear indxd2 rBd;                     % clear auxiliary variables
     end


 %% Division  

 %%%%%%%%%%%% Type A cells %%%%%%%%%%%% 
  % Type A that are ready to divide  
    indx1 = find(cellstypeACC==k);          % Index of cells that divide this time step
    if ~isempty(indx1)
        rA        = ones(1,numTypeA);
        rA(indx1) = rand(1,length(indx1));  % random number generator
        clear indx1;
     
     %% Symmetric division of type A (increase count of type A by 2 per cell)
        indxp1   = find(rA < P1A);          % Find which cells will divide this way
        if ~isempty(indxp1)
            lenA    = numTypeA;             % Current number of type A
            lenAnew =  2*length(indxp1);    % 2 times the number of cell dividing
          % increase cell count by 2  
            numTypeA = lenA + lenAnew; 
            rA(end+1:end+lenAnew) = 1;
          % Make the new cells one generation above than their "mothers"
            cellstypeAgen(lenA+1:lenA+lenAnew) = repmat(cellstypeAgen(indxp1),1,2) + 1;
          % Determine the length of the cell cycle for the new cells
            cellstypeACC(lenA+1:lenA+lenAnew) = abs(ceil(meanCCA + stdCCA*randn(lenAnew,1))) + k + 1;
          % Update the length of the cell cycle for the mothers so they can divide again
            cellstypeACC(indxp1) = cellstypeACC(indxp1) + k + 1;
          % Update the counter of the cells for the number of times the have divided
            cellstypeAdiv(indxp1) =  cellstypeAdiv(indxp1) + 1;
          % New cells have divided zero times
            cellstypeAdiv(lenA+1:lenA+lenAnew) = 0;
        end
        clear indxp1;                       % clear auxiliary variables

     %% Asymmetric of type A (increase count of type A by 1 and B by 1 per cell)
        indxp2 = find(rA > P1A & rA<(P1A+P2A)); % Find which cells will divide this way
        if ~isempty(indxp2)
            lenA     = numTypeA;
            lenB     = numTypeB;
            lenABnew = length(indxp2);
          % increase cell count for A by 1 for each cell
            numTypeA = lenA + lenABnew;
            rA(end+1:end+lenABnew) = 1;
          % Check how many of the B cells go quiescent
            r1Q    = rand(1,lenABnew);
            indxQ  = find(r1Q > PQB);
            indxQ2 = r1Q <= PQB;
            numTypeBQ = numTypeBQ + length(indxQ);
            keepB = cellstypeAgen(indxp2(indxQ2));
          % increase cell count for B by 1 per cell minus the quiescent
            newlenB  = lenABnew - length(indxQ);
            numTypeB = numTypeB + newlenB;
          % Make them one generation above their mothers
            cellstypeAgen(lenA+1:lenA+lenABnew) = cellstypeAgen(indxp2)+1;
            cellstypeBgen(lenB+1:lenB+newlenB) = keepB'+1;
          % Determine the length of their cell cycle
            cellstypeACC(lenA+1:lenA+lenABnew) = abs(ceil(meanCCA + stdCCA*randn(lenABnew,1)))+ k + 1;
            cellstypeBCC(lenB+1:lenB+newlenB)  = abs(ceil(meanCCB + stdCCB*randn(newlenB,1)))+ k + 1;
          % Update mothers' length of cell cyle
            cellstypeACC(indxp2) = cellstypeACC(indxp2) + k + 1;
          % Update number of divisions for the mothers
            cellstypeAdiv(indxp2) = cellstypeAdiv(indxp2) + 1;
          % New cells have divied zero times
            cellstypeAdiv(lenA+1:lenA+lenABnew) = 0;
            cellstypeBdiv(lenB+1:lenB+newlenB)  = 0;
        end
        clear indxp2 r1Q indxQ indxQ2 keepB;    % clear auxiliary variables

     %% One Differentitation of type A (decrease count of A by 1 and increase B by 1 per cell)
        indxp3 = find(rA > (P1A+P2A)& rA<(P1A+P2A+P3A));    % Find which cells will divide this way
        if ~isempty(indxp3)
            lenB      = numTypeB;
            lenminusA = length(indxp3);
            numTypeA  = numTypeA - lenminusA;          % decrease cell count for A by 1
            rA(indxp3) = [];
          % Check how many of the newly created type B cells go quiescent
            r1Q    = rand(1,lenminusA);
            indxQ  = find(r1Q > PQB);
            indxQ2 = r1Q <= PQB;
            numTypeBQ = numTypeBQ + length(indxQ);
            keepB = cellstypeAgen(indxp3(indxQ2));
          % increase cell count for B by 1 per cell minus the quiescent
            newlenB  = lenminusA - length(indxQ);
            numTypeB = numTypeB + newlenB;
            if lenB == 0
                cellstypeBgen(1:newlenB) = keepB' + 1;      % Make them one generation above their mothers
                cellstypeBCC(1:newlenB) = abs(ceil(meanCCB + stdCCB*randn(newlenB,1)))+ k + 1; % determine the length of their cell cycle
                cellstypeBdiv(1:newlenB) = 0;               % New cells have divied zero times
            else
                cellstypeBgen(lenB+1:lenB+newlenB) = keepB' + 1; % Make them one generation above their mothers
                cellstypeBCC(lenB+1:lenB+newlenB) = abs(ceil(meanCCB + stdCCB*randn(newlenB,1)))+ k + 1; % determine the length of their cell cycle
                cellstypeBdiv(lenB+1:lenB+newlenB) = 0;      % New cells have divied zero times
            end
          % Erase data for the mothers
            cellstypeAgen(indxp3) = [];
            cellstypeAdiv(indxp3) = [];
            cellstypeACC(indxp3)  = [];
        end
        clear indxp3 r1Q indxQ indxQ2 keepB;                 % clear auxiliary variables

     %% Two Differentitation of type A  (decrease count of A by 1 and increase B by 2 per cell)
        indxp4 = find(rA > (P1A+P2A+P3A)& rA<1);    % Find which cells will divide this way
        if ~isempty(indxp4)
            lenB = numTypeB;
            numTypeA = numTypeA - 1*length(indxp4); % decrease cell count for A by 1
            rA(indxp4) = [];
          % Check how many of the newly created type B cells go quiescent
            r1Q    = rand(1,length(indxp4));
            indxQ  = find(r1Q > PQB);
            indxQ2 = r1Q <= PQB;
            numTypeBQ = numTypeBQ + length(indxQ);
            keepB = cellstypeAgen(indxp4(indxQ2));
          % increase cell count for B by 2 per cell minus the quiescent
            newlenB  = 2*(length(indxp4) - length(indxQ));
            numTypeB = numTypeB + newlenB;
            if lenB == 0
                cellstypeBgen(1:newlenB) = repmat(keepB',1,2)  + 1; % Make them one generation above their mothers
                cellstypeBCC(1:newlenB) = abs(ceil(meanCCB + stdCCB*randn(newlenB,1)))+ k + 1; % determine the length of their cell cycle
                cellstypeBdiv(1:newlenB) = 0;       % New cells have divied zero times
            else
                cellstypeBgen(lenB+1:lenB+newlenB) = repmat(keepB',1,2)  + 1; % Make them one generation above their mothers
                cellstypeBCC(lenB+1:lenB+newlenB) = abs(ceil(meanCCB + stdCCB*randn(newlenB,1)))+ k + 1; % determine the length of their cell cycle
                cellstypeBdiv(lenB+1:lenB+newlenB) = 0;     % New cells have divied zero times
            end
          % Erase data for the mothers
            cellstypeAgen(indxp4) = [];
            cellstypeAdiv(indxp4) = [];
            cellstypeACC(indxp4)  = [];
        end
        clear indxp4 r1Q indxQ indxQ2 keepB % clear auxiliary variables
    end
    clear rA

      

 %%%%%%%%%%%% Type B cells %%%%%%%%%%%%

    % Type B that are ready to divide  
      indx2 = find(cellstypeBCC==k);
      if ~isempty(indx2)
          rB        = ones(1,numTypeB);
          rB(indx2) = rand(1,length(indx2)); % random number generator

       %% Symmetric division of type B (increase count of type B by 2 per cell)
          indxp1   = find(rB < P1B);    % Find which cells will divide this way
          if ~isempty(indxp1)
              lenB = numTypeB;
              numTypeB = numTypeB + 2*length(indxp1);  % increase cell count by 2
              rB(end+1:end+2*length(indxp1)) = 1;
              cellstypeBgen(lenB+1:lenB+2*length(indxp1)) = repmat(cellstypeBgen(indxp1),1,2) + 1; % make the new cells one generation above than their "mothers"
              cellstypeBCC(lenB+1:lenB+2*length(indxp1)) = abs(ceil(meanCCB + stdCCB*randn(2*length(indxp1),1))) + k + 1; % Determine the length of the cell cycle for the new cells
              cellstypeBCC(indxp1) = cellstypeBCC(indxp1) + k + 1;  % Update the length of the cell cycle for the mothers so they can divide again
              cellstypeBdiv(indxp1) =  cellstypeBdiv(indxp1) + 1;   % Update the counter of the cells for the number of times the have divided
              cellstypeBdiv(lenB+1:lenB+2*length(indxp1)) = 0;      % New cells have divided zero times
          end
          clear indxp1 indx2;           % clear auxiliary variables

       %% Asymmetric of type B (increase count of type B by 1 and C by 1 per cell)
          indxp2 = find(rB > P1B & rB<(P1B+P2B)); % Find which cells will divide this way
          if ~isempty(indxp2)
              lenB = numTypeB;
              lenC = numTypeC;
              numTypeB = numTypeB + 1*length(indxp2); % increase cell count for B by 1
              rB(end+1:end+1*length(indxp2)) = 1;
              numTypeC = numTypeC + 1*length(indxp2); % increase cell count for C by 1
              cellstypeBgen(lenB+1:lenB+length(indxp2)) = cellstypeBgen(indxp2)+1; % Make them one generation above their mothers
              cellstypeCgen(lenC+1:lenC+length(indxp2)) = cellstypeBgen(indxp2)+1;
              cellstypeBCC(lenB+1:lenB+length(indxp2)) = abs(ceil(meanCCB + stdCCB*randn(length(indxp2),1)))+ k + 1;  % determine the length of their cell cycle              
              cellstypeBCC(indxp2) = cellstypeBCC(indxp2) + k + 1;  % Update mothers' length of cell cyle
              cellstypeBdiv(indxp2) = cellstypeBdiv(indxp2) + 1;  % update number of divisions for the mothers
              cellstypeBdiv(lenB+1:lenB+length(indxp2)) = 0;  % New cells have divied zero times
          end
          clear indxp2;             % clear auxiliary variables

          
       %% one Differentitation of type B (decrease count of B by 1 and increase C by 1 per cell)
          indxp3 = find(rB > (P1B+P2B)& rB<(P1B+P2B+P3B)); % Find which cells will divide this way
          if ~isempty(indxp3)
              lenB = numTypeB;
              lenC = numTypeC;
              numTypeB = numTypeB - 1*length(indxp3);  % decrease cell count for B by 1
              rB(indxp3) = [];
              numTypeC = numTypeC + 1*length(indxp3);  % increase cell count for C by 1
              if lenC == 0
                  cellstypeCgen(1:length(indxp3)) = cellstypeBgen(indxp3) + 1; % Make them one generation above their mothers
              else
                  cellstypeCgen(lenB+1:lenB+length(indxp3)) = cellstypeBgen(indxp3) + 1; % Make them one generation above their mothers
              end
            % Erase data for the mothers  
              cellstypeBgen(indxp3) = [];  
              cellstypeBdiv(indxp3) = [];
              cellstypeBCC(indxp3)  = [];
          end
          clear indxp3 % clear auxiliary variables

       %% Two Differentitation of type B (decrease count of B by 1 and increase C by 2 per cell)
          indxp4 = find(rB > (P1B+P2B+P3B)& rB<1); % Find which cells will divide this way
          if ~isempty(indxp4)
              lenB = numTypeB;
              lenC = numTypeC;
              numTypeB = numTypeB - 1*length(indxp4);  % decrease cell count for B by 1
              rB(indxp4) = [];
              numTypeC = numTypeC + 2*length(indxp4);  % increase cell count for C by 2
              if lenC == 0
                  cellstypeCgen(1:2*length(indxp4)) = repmat(cellstypeBgen(indxp4),1,2) + 1; % Make them one generation above their mothers
              else
                  cellstypeCgen(lenB+1:lenB+2*length(indxp4)) = repmat(cellstypeBgen(indxp4),1,2) + 1; % Make them one generation above their mothers
              end
            % Erase data for the mothers  
              cellstypeBgen(indxp4) = [];  
              cellstypeBdiv(indxp4) = [];
              cellstypeBCC(indxp4)  = [];
          end
          clear indxp4 % clear auxiliary variables          
      end
      clear rB


    %% Update numbers
       cellstypeA.Num(k+1)  = numTypeA;
       cellstypeB.Num(k+1)  = numTypeB;
       cellstypeA.NumQ(k+1) = numTypeAQ;
       cellstypeB.NumQ(k+1) = numTypeBQ;
       cellstypeA.NumI(k+1) = numTypeAI;
       cellstypeB.NumI(k+1) = numTypeBI;
       cellstypeC.Num(k+1)  = numTypeC;

       cellstypeA.CC{k+1}  = cellstypeACC;
       cellstypeA.gen{k+1} = cellstypeAgen;
       cellstypeA.div{k+1} = cellstypeAdiv;
       cellstypeB.CC{k+1}  = cellstypeBCC;
       cellstypeB.gen{k+1} = cellstypeBgen;
       cellstypeB.div{k+1} = cellstypeBdiv;
       cellstypeC.gen{k+1} = cellstypeCgen;

  end

%% Save model parameters  
   params.seed = seed;
   params.Nc   = Nc;
   params.Nt   = Nt;

   params.PQA  = PQA;
   params.PQB  = PQB;

   params.P1A  = P1A;
   params.P2A  = P2A;
   params.P3A  = P3A;
   params.P4A  = P4A;

   params.P1B = P1B;
   params.P2B = P2B;
   params.P3B = P3B;
   params.P4B = P4B;

   params.PAA = PAA;
   params.PAB = PAB;

   params.PAQA = PAQA;
   params.PAQB = PAQB;

   params.meanCCA = meanCCA;
   params.stdCCA  = stdCCA;
   params.meanCCB = meanCCB;
   params.stdCCB  = stdCCB;

   params.max_divisions_A = max_divisions_A;
   params.max_divisions_B = max_divisions_B;


%% Plotting 
   figure('Position',[100,500,1100,800])
   plot(cellstypeA.Num,'LineWidth',2,LineStyle='--') %active 
   set(gca, 'YScale', 'log');
   %hold on
   %plot(cellstypeA.NumQ,'LineWidth',2,LineStyle='-.') %quiescence
   %plot(cellstypeA.NumI,'LineWidth',2,LineStyle=':')
   %plot(cellstypeA.NumI+cellstypeA.Num+cellstypeA.NumQ,'LineWidth',3,LineStyle='-')
   %plot(cellstypeA.NumQ+cellstypeA.NumI,'LineWidth',2,'LineStyle','-')
   legend("LT-HSCs")
   %legend('Active', 'Quiescent', 'Inactive','Total','Quiescent + Inactive')
   title('LT-HSCs')
   ax = gca; ax.FontSize=28; ax.LineWidth=1.5;
   %%ylim([10^3, 10^6])
   %yscale log

   figure('Position',[100,500,1100,800])
   plot(cellstypeB.Num,'LineWidth',2,LineStyle='--')
   set(gca, 'YScale', 'log');
   %hold on
   %plot(cellstypeB.NumQ,'LineWidth',2,LineStyle='-.')
   %plot(cellstypeB.NumI,'LineWidth',2,LineStyle=':')
   %plot(cellstypeB.NumI+cellstypeB.Num+cellstypeB.NumQ,'LineWidth',3,LineStyle='-')
   %plot(cellstypeB.NumQ+cellstypeB.NumI,'LineWidth',2,'LineStyle','-')
   legend("ST-HSCs")
   %legend('Active', 'Quiescent', 'Inactive','Total','Quiescent + Inactive')
   title('ST-HSCs')
   ax = gca; ax.FontSize=28; ax.LineWidth=1.5;
   %yscale log



   




