function [cellstypeA, cellstypeB, cellstypeC, params] = cellmodel_diff_spaQD(varargin) %Accepting variable

%% Last updated Oct 8, 2024

% Parsing the input parameters
  p = setup;
  parse(p, varargin{:});

% Using parsed parameters
  [PQA, PQB, PQC, P1A, P2A, P3A, P4A, P1B, P2B, P3B, P4B, PAA, PAB, PAQA, PAQB,...
    meanCCA, stdCCA, meanCCB, stdCCB, meanCCC, stdCCC, max_divisions_A, max_divisions_B,...
    Lx, Ly, dtBrow, Df, EV, aQ, aD] = setupconst(p);

% Random seed
  seed = 123456789;
  rng(seed)

% Parameters
  Nc = 1e4;             % Initial number of cells
  Nt = 5;             % total number of time steps (assumed days)


% Initial conditions 
  [numTypeAQ,numTypeA,numTypeAI,numTypeB,numTypeBI,numTypeBQ,numTypeC,numTypeCQ,...
    cellstypeA,cellstypeB,cellstypeC,xA,yA,xAQ,yAQ,xAI,yAI,xB,yB,xBQ,yBQ,xBI,yBI,...
    xC,yC,xCQ,yCQ,xCI,yCI] = initializevars(Nc,Lx,Ly,PQA,meanCCA,stdCCA,aQ,aD);  

%% Begin time evolution
   for k = 1:Nt

   %% Temporary store data from previous step
      cellstypeACC  = cellstypeA.CC{k};
      cellstypeAgen = cellstypeA.gen{k};
      cellstypeAdiv = cellstypeA.div{k};
      cellstypeBCC  = cellstypeB.CC{k};
      cellstypeBgen = cellstypeB.gen{k};
      cellstypeBdiv = cellstypeB.div{k};
      cellstypeCCC  = cellstypeC.CC{k};
      cellstypeCgen = cellstypeC.gen{k};
      cellstypeCdiv = cellstypeC.div{k};
      

   %% Inactive Cells

    % Type A cells
      [numTypeA,numTypeAI,cellstypeACC,cellstypeAgen,cellstypeAdiv,xA,yA,xAI,yAI] = ...
           inactivecells(cellstypeAdiv,max_divisions_A,numTypeA,numTypeAI,...
                          cellstypeACC,cellstypeAgen,xA,yA,xAI,yAI);
    % Type B cells
      [numTypeB,numTypeBI,cellstypeBCC,cellstypeBgen,cellstypeBdiv,xB,yB,xBI,yBI] = ...
           inactivecells(cellstypeBdiv,max_divisions_B,numTypeB,numTypeBI,...
                          cellstypeBCC,cellstypeBgen,xB,yB,xBI,yBI);


   %% Apoptosis

    % Type A cells
      [numTypeA,numTypeAQ,cellstypeACC,cellstypeAgen,cellstypeAdiv,xA,yA,xAQ,yAQ] = ...
            apoptosis(numTypeA,numTypeAQ,PAA,PAQA,...
                      cellstypeACC,cellstypeAgen,cellstypeAdiv,xA,yA,xAQ,yAQ);

    % Type B cells
      [numTypeB,numTypeBQ,cellstypeBCC,cellstypeBgen,cellstypeBdiv,xB,yB,xBQ,yBQ] = ...
            apoptosis(numTypeB,numTypeBQ,PAB,PAQB,...
                      cellstypeBCC,cellstypeBgen,cellstypeBdiv,xB,yB,xBQ,yBQ);


 %% Division  

 %%%%%%%%%%%% Type A cells %%%%%%%%%%%% 
  % Type A that are ready to divide  
    indx1 = find(cellstypeACC==k);          % Index of cells that divide this time step
    if ~isempty(indx1)
        rA        = ones(1,numTypeA);
        rA(indx1) = rand(1,length(indx1));  % random number generator
        clear indx1;

    %% Symmetric division of type A (increase count of type A by 2 per cell)   
       [rA,numTypeA,cellstypeAgen,cellstypeACC,cellstypeAdiv,xA,yA] = ...
             symdiv(k,rA,P1A,numTypeA,meanCCA,stdCCA,...
                    cellstypeAgen,cellstypeACC,cellstypeAdiv,xA,yA,aQ,aD,Lx,Ly);

     %% Asymmetric of type A (increase count of type A by 1 and B by 1 per cell)
        [rA,numTypeA,numTypeB,numTypeBQ,cellstypeAgen,cellstypeBgen,cellstypeACC,...
            cellstypeBCC,cellstypeAdiv,cellstypeBdiv,xA,yA,xB,yB,xBQ,yBQ] = asymdiv(k,rA,P1A,P2A,PQB,...
            numTypeA,numTypeB,numTypeBQ,meanCCA,meanCCB,stdCCA,stdCCB,...
            cellstypeAgen,cellstypeBgen,cellstypeACC,cellstypeBCC,...
            cellstypeAdiv,cellstypeBdiv,xA,yA,xB,yB,xBQ,yBQ,aQ,aD,Lx,Ly);

     %% One Differentitation of type A (decrease count of A by 1 and increase B by 1 per cell)
        [rA,numTypeA,numTypeB,numTypeBQ,cellstypeAgen,cellstypeBgen,cellstypeACC,cellstypeBCC,...
            cellstypeAdiv,cellstypeBdiv,xA,yA,xB,yB,xBQ,yBQ] = onediff(k,rA,P1A,P2A,P3A,PQB,meanCCB,stdCCB,...
            numTypeA,numTypeB,numTypeBQ,cellstypeAgen,cellstypeBgen,cellstypeACC,...
            cellstypeBCC,cellstypeAdiv,cellstypeBdiv,xA,yA,xB,yB,xBQ,yBQ,aQ,aD,Lx,Ly);   
     
     %% Two Differentitation of type A  (decrease count of A by 1 and increase B by 2 per cell)   
        [rA,numTypeA,numTypeB,numTypeBQ,cellstypeAgen,cellstypeBgen,cellstypeACC,cellstypeBCC,...
            cellstypeAdiv,cellstypeBdiv,xA,yA,xB,yB,xBQ,yBQ] = twodiff(k,rA,P1A,P2A,P3A,PQB,numTypeA,numTypeB,numTypeBQ,...
            meanCCB,stdCCB,cellstypeAgen,cellstypeBgen,cellstypeACC,cellstypeBCC,cellstypeAdiv,cellstypeBdiv,xA,yA,xB,yB,xBQ,yBQ,aQ,aD,Lx,Ly);
    end
    clear rA

      

 %%%%%%%%%%%% Type B cells %%%%%%%%%%%%

    % Type B that are ready to divide  
      indx2 = find(cellstypeBCC==k);
      if ~isempty(indx2)
          rB        = ones(1,numTypeB);
          rB(indx2) = rand(1,length(indx2)); % random number generator

       %% Symmetric division of type B (increase count of type B by 2 per cell)
          [rB,numTypeB,cellstypeBgen,cellstypeBCC,cellstypeBdiv,xB,yB] = ...
          symdiv(k,rB,P1B,numTypeB,meanCCB,stdCCB,...
                 cellstypeBgen,cellstypeBCC,cellstypeBdiv,xB,yB,aQ,aD,Lx,Ly);

       %% Asymmetric of type B (increase count of type B by 1 and C by 1 per cell)
          [rB,numTypeB,numTypeC,numTypeCQ,cellstypeBgen,cellstypeCgen,cellstypeBCC,...
            cellstypeCCC,cellstypeBdiv,cellstypeCdiv,xB,yB,xC,yC,xCQ,yCQ] = asymdiv(k,rB,P1B,P2B,PQC,...
            numTypeB,numTypeC,numTypeCQ,meanCCB,meanCCC,stdCCB,stdCCC,...
            cellstypeBgen,cellstypeCgen,cellstypeBCC,cellstypeCCC,...
            cellstypeBdiv,cellstypeCdiv,xB,yB,xC,yC,xCQ,yCQ,aQ,aD,Lx,Ly);

       %% One Differentitation of type B (decrease count of B by 1 and increase C by 1 per cell)
          [rB,numTypeB,numTypeC,numTypeCQ,cellstypeBgen,cellstypeCgen,cellstypeBCC,cellstypeCCC,...
            cellstypeBdiv,cellstypeCdiv,xB,yB,xC,yC,xCQ,yCQ] = onediff(k,rB,P1B,P2B,P3B,PQC,meanCCC,stdCCC,...
            numTypeB,numTypeC,numTypeCQ,cellstypeBgen,cellstypeCgen,cellstypeBCC,...
            cellstypeCCC,cellstypeBdiv,cellstypeCdiv,xB,yB,xC,yC,xCQ,yCQ,aQ,aD,Lx,Ly); 

       %% Two Differentitation of type B (decrease count of B by 1 and increase C by 2 per cell)
          [rB,numTypeB,numTypeC,numTypeCQ,cellstypeBgen,cellstypeCgen,cellstypeBCC,cellstypeCCC,...
              cellstypeBdiv,cellstypeCdiv,xB,yB,xC,yC,xCQ,yCQ] = twodiff(k,rB,P1B,P2B,P3B,PQC,numTypeB,numTypeC,numTypeCQ,...
              meanCCC,stdCCC,cellstypeBgen,cellstypeCgen,cellstypeBCC,cellstypeCCC,cellstypeBdiv,cellstypeCdiv,xB,yB,xC,yC,xCQ,yCQ,aQ,aD,Lx,Ly);          
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
       cellstypeC.CC{k+1}  = cellstypeCCC;
       cellstypeC.gen{k+1} = cellstypeCgen;
       cellstypeC.div{k+1} = cellstypeCdiv;

    %% Update cells positions
       if Df ~= 0
           [xA,yA] = diff2dEV_cells(xA,yA,1440,dtBrow,EV,Df,Lx,Ly);
           [xB,yB] = diff2dEV_cells(xB,yB,1440,dtBrow,EV,Df,Lx,Ly);
           [xC,yC] = diff2dEV_cells(xC,yC,1440,dtBrow,EV,Df,Lx,Ly);
       end
       cellstypeA.xyA{k+1}  = [xA,yA];
       cellstypeA.xyAQ{k+1} = [xAQ,yAQ];
       cellstypeA.xyAI{k+1} = [xAI,yAI];
       cellstypeB.xyB{k+1}  = [xB,yB];
       cellstypeB.xyBQ{k+1} = [xBQ,yBQ];
       cellstypeB.xyBI{k+1} = [xBI,yBI];
       cellstypeC.xyC{k+1}  = [xC,yC];
       cellstypeC.xyCQ{k+1} = [xCQ,yCQ];
       cellstypeC.xyCI{k+1} = [xCI,yCI];

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
   %set(gca, 'YScale', 'log');
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
   %set(gca, 'YScale', 'log');
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



   




