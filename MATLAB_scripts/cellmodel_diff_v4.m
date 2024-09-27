function [cellstypeA, cellstypeB, cellstypeC, params] = cellmodel_diff_v4(varargin)

%% Last updated Sep 21, 2024

%% Setting up simulation parameters

 % Parameters
   Nc = 1e4;             % Initial number of cells
   Nt = 150;             % total number of time steps (assumed days)

 % Parsing the input parameters
   p = setupp;
   parse(p, varargin{:});

 % Using parsed parameters to set constants
   [PQA, PQB, P1A, P2A, P3A, P4A, P1B, P2B, P3B, P4B, PAA, PAB, PAQA, PAQB,...
    meanCCA, stdCCA, meanCCB, stdCCB, meanCCC, stdCCC, max_divisions_A, max_divisions_B,...
    Lx, Ly, dtBrow, Df, EV, a, a1, seed] = setupconst(p);

 % Random seed
   rng(seed)  

%% Initial conditions 
   [xA, yA, xAQ, yAQ, xAI, yAI, xB, yB, xBQ, yBQ, xBI, yBI, xC, yC,...
    numTypeAQ, numTypeA, numTypeAI, numTypeB,numTypeBI, ...
    numTypeBQ, numTypeC, cellstypeA, cellstypeB,...
    cellstypeC] = initializevars(Nc,Lx,Ly,PQA,meanCCA,stdCCA,a);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
   % Check which cells had divided enough times -> stop dividing and become innactive

   %%%%%%%%%%%% Type A cells %%%%%%%%%%%%
   [cellstypeACC,cellstypeAgen,cellstypeAdiv,xA,yA,xAI,yAI,numTypeA,numTypeAI] = inactivecells(...
             max_divisions_A,cellstypeAdiv,numTypeA,numTypeAI,...
             cellstypeACC,cellstypeAgen,xA,yA,xAI,yAI);

   %%%%%%%%%%%% Type B cells %%%%%%%%%%%%
   [cellstypeBCC,cellstypeBgen,cellstypeBdiv,xB,yB,xBI,yBI,numTypeB,numTypeBI] = inactivecells(...
             max_divisions_B,cellstypeBdiv,numTypeB,numTypeBI,...
             cellstypeBCC,cellstypeBgen,xB,yB,xBI,yBI);


  %% Apoptosis
   % Determine which cells die in this time step

   %%%%%%%%%%%% Type A cells %%%%%%%%%%%%
   [numTypeA,cellstypeACC,cellstypeAgen,cellstypeAdiv,xA,yA] =...
            apoptosis(numTypeA,PAA,cellstypeACC,cellstypeAgen,cellstypeAdiv,xA,yA);
  
   %%%%%%%%%%%% Type B cells %%%%%%%%%%%%
   [numTypeB,cellstypeBCC,cellstypeBgen,cellstypeBdiv,xB,yB] =...
            apoptosis(numTypeB,PAB,cellstypeBCC,cellstypeBgen,cellstypeBdiv,xB,yB);


  %% Quiescence
   %%%%%%%%%%%% Type A cells %%%%%%%%%%%%
   [cellstypeACC,cellstypeAgen,cellstypeAdiv,numTypeA,numTypeAQ,xAQ,yAQ,xA,yA] = ...
      quiescence(cellstypeACC,cellstypeAgen,cellstypeAdiv,numTypeA,numTypeAQ,PQA,xAQ,yAQ,xA,yA,Lx,a);
  
   %%%%%%%%%%%% Type B cells %%%%%%%%%%%%
   [cellstypeBCC,cellstypeBgen,cellstypeBdiv,numTypeB,numTypeBQ,xBQ,yBQ,xB,yB] = ...
      quiescence(cellstypeBCC,cellstypeBgen,cellstypeBdiv,numTypeB,numTypeBQ,PQB,xBQ,yBQ,xB,yB,Lx,a);


  %% Apoptosis quiescent

   %%%%%%%%%%%% Type A cells %%%%%%%%%%%%
   [numTypeAQ] = apopQuies(numTypeAQ,PAQA);
  
   %%%%%%%%%%%% Type B cells %%%%%%%%%%%%
   [numTypeBQ] = apopQuies(numTypeBQ,PAQB); 


  %% Division  
  %%%%%%%%%%%% Type A cells %%%%%%%%%%%% 
   % Type A that are ready to divide  
     indx1 = find(cellstypeACC==k);          % Index of cells that divide this time step
     if ~isempty(indx1)
         rA        = ones(1,numTypeA);
         rA(indx1) = rand(1,length(indx1));  % random number generator
         clear indx1;
     
    %% Symmetric division of type A (increase count of type A by 2 per cell)
       [rA,numTypeA,xA,yA,cellstypeAgen,cellstypeACC,cellstypeAdiv] = ...
           symdiv(rA,P1A,numTypeA,xA,yA,cellstypeAgen,cellstypeACC,...
                  cellstypeAdiv,meanCCA,stdCCA,k,Ly,a1);

    %% Asymmetric of type A (increase count of type A by 1 and B by 1 per cell)
       [rA,numTypeA,numTypeB,xA,yA,xB,yB,cellstypeAgen,cellstypeACC,cellstypeAdiv,...
           cellstypeBgen,cellstypeBCC,cellstypeBdiv] = asymdiv(rA,P1A,P2A,...
           numTypeA,numTypeB,xA,yA,xB,yB,cellstypeAgen,cellstypeACC,cellstypeAdiv,...
           cellstypeBgen,cellstypeBCC,cellstypeBdiv,meanCCA,stdCCA,meanCCB,stdCCB,k,Ly,a1);
        
    %% One Differentitation of type A (decrease count of A by 1 and increase B by 1 per cell)
       [rA,numTypeA,numTypeB,cellstypeAgen,cellstypeBgen,cellstypeACC,...
           cellstypeBCC,cellstypeAdiv,cellstypeBdiv,xA,yA,xB,yB] = ...
           diffone(rA,P1A,P2A,P3A,numTypeA,numTypeB,cellstypeAgen,cellstypeBgen,...
           cellstypeACC,cellstypeBCC,cellstypeAdiv,cellstypeBdiv,xA,yA,xB,yB,meanCCB,stdCCB,k,Ly,a1);

    %% Two Differentitation of type A  (decrease count of A by 1 and increase B by 2 per cell)
       [numTypeA,numTypeB,cellstypeAgen,cellstypeBgen,...
           cellstypeACC,cellstypeBCC,cellstypeAdiv,cellstypeBdiv,xA,yA,xB,yB,meanCCB,stdCCB] = ...
           difftwo(rA,P1A,P2A,P3A,numTypeA,numTypeB,cellstypeAgen,cellstypeBgen,...
           cellstypeACC,cellstypeBCC,cellstypeAdiv,cellstypeBdiv,xA,yA,xB,yB,meanCCB,stdCCB,k,Ly,a1);
    
    end
    clear rA
     

 %%%%%%%%%%%% Type B cells %%%%%%%%%%%%

    % Type B that are ready to divide  
      indx2 = find(cellstypeBCC==k);
      if ~isempty(indx2)
          rB        = ones(1,numTypeB);
          rB(indx2) = rand(1,length(indx2)); % random number generator

      %% Symmetric division of type B (increase count of type B by 2 per cell)
         [rB,numTypeB,xB,yB,cellstypeBgen,cellstypeBCC,cellstypeBdiv] = ...
           symdiv(rB,P1B,numTypeB,xB,yB,cellstypeBgen,cellstypeBCC,...
                  cellstypeBdiv,meanCCB,stdCCB,k,Ly,a1);

      %% Asymmetric of type B (increase count of type B by 1 and C by 1 per cell)
         [rB,numTypeB,numTypeC,xB,yB,xC,yC,cellstypeBgen,cellstypeBCC,cellstypeBdiv,...
           cellstypeCgen,cellstypeCCC,cellstypeCdiv] = asymdiv(rB,P1B,P2B,...
           numTypeB,numTypeC,xB,yB,xC,yC,cellstypeBgen,cellstypeBCC,cellstypeBdiv,...
           cellstypeCgen,cellstypeCCC,cellstypeCdiv,meanCCB,stdCCB,meanCCC,stdCCC,k,Ly,a1);

          
      %% one Differentitation of type B (decrease count of B by 1 and increase C by 1 per cell)
         [rB,numTypeB,numTypeC,cellstypeBgen,cellstypeCgen,cellstypeBCC,...
           cellstypeCCC,cellstypeBdiv,cellstypeCdiv,xB,yB,xC,yC] = ...
           diffone(rB,P1B,P2B,P3B,numTypeB,numTypeC,cellstypeBgen,cellstypeCgen,...
           cellstypeBCC,cellstypeCCC,cellstypeBdiv,cellstypeCdiv,xB,yB,xC,yC,meanCCC,stdCCC,k,Ly,a1);

      %% Two Differentitation of type B (decrease count of B by 1 and increase C by 2 per cell)          
         [numTypeB,numTypeC,cellstypeBgen,cellstypeCgen,...
           cellstypeBCC,cellstypeCCC,cellstypeBdiv,cellstypeCdiv,xB,yB,xC,yC,meanCCC,stdCCC] = ...
           difftwo(rB,P1B,P2B,P3B,numTypeB,numTypeC,cellstypeBgen,cellstypeCgen,...
           cellstypeBCC,cellstypeCCC,cellstypeBdiv,cellstypeCdiv,xB,yB,xC,yC,meanCCC,stdCCC,k,Ly,a1); 
      end
      clear rB


    
  %% Update numbers
     cellstypeA.Num(k+1)  = numTypeA;
     cellstypeB.Num(k+1)  = numTypeB;
     cellstypeC.Num(k+1)  = numTypeC;
     cellstypeA.NumQ(k+1) = numTypeAQ;
     cellstypeB.NumQ(k+1) = numTypeBQ;
     cellstypeA.NumI(k+1) = numTypeAI;
     cellstypeB.NumI(k+1) = numTypeBI;


     cellstypeA.CC{k+1}  = cellstypeACC;
     cellstypeA.gen{k+1} = cellstypeAgen;
     cellstypeA.div{k+1} = cellstypeAdiv;
     cellstypeB.CC{k+1}  = cellstypeBCC;
     cellstypeB.gen{k+1} = cellstypeBgen;
     cellstypeB.div{k+1} = cellstypeBdiv;
     cellstypeC.CC{k+1}  = cellstypeCCC;
     cellstypeC.gen{k+1} = cellstypeCgen;
     cellstypeC.div{k+1} = cellstypeCdiv;

     cellstypeA.xyA{k+1}  = [xA,yA];
     cellstypeA.xyAQ{k+1} = [xAQ,yAQ];
     cellstypeA.xyAI{k+1} = [xAI,yAI];
     cellstypeB.xyB{k+1}  = [xB,yB];
     cellstypeB.xyBQ{k+1} = [xBQ,yBQ];
     cellstypeB.xyBI{k+1}  = [xBI,yBI];
     cellstypeC.xyC{k+1}  = [xC,yC];


  %% Update cells positions
     if Df ~= 0
         [xA,yA] = diff2dEV_cells(xA,yA,1440,dtBrow,EV,Df,Lx,Ly);
         [xB,yB] = diff2dEV_cells(xB,yB,1440,dtBrow,EV,Df,Lx,Ly);
         [xC,yC] = diff2dEV_cells(xC,yC,1440,dtBrow,EV,Df,Lx,Ly);
     end

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

   params.Lx     = Lx;
   params.Ly     = Ly;
   params.dtBrow = dtBrow;
   params.Df     = Df;
   params.EV     = EV;
   params.a      = a;
   params.a1     = a1;


% %% Plotting 
    figure('Position',[100,500,1100,800])
    plot(cellstypeA.Num,'LineWidth',2,LineStyle='--') %active 
    %set(gca, 'YScale', 'log');
    hold on
    plot(cellstypeA.NumQ,'LineWidth',2,LineStyle='-.') %quiescence
    plot(cellstypeA.NumI,'LineWidth',2,LineStyle=':')
    %plot(cellstypeA.NumI+cellstypeA.Num+cellstypeA.NumQ,'LineWidth',3,LineStyle='-')
    plot(cellstypeA.NumQ+cellstypeA.NumI,'LineWidth',2,'LineStyle','-')%    legend("LT-HSCs")
    legend('Active', 'Quiescent', 'Inactive','Total')
    title('LT-HSCs')
    ax = gca; ax.FontSize=28; ax.LineWidth=1.5;
    %%ylim([10^3, 10^6])
    %yscale log
% 
    figure('Position',[100,500,1100,800])
    plot(cellstypeB.Num,'LineWidth',2,LineStyle='--')
    %set(gca, 'YScale', 'log');
    %hold on
    plot(cellstypeB.NumQ,'LineWidth',2,LineStyle='-.')
    plot(cellstypeB.NumI,'LineWidth',2,LineStyle=':')
    %plot(cellstypeB.NumI+cellstypeB.Num+cellstypeB.NumQ,'LineWidth',3,LineStyle='-')
    plot(cellstypeB.NumQ+cellstypeB.NumI,'LineWidth',2,'LineStyle','-')
    %legend("ST-HSCs")
    legend('Active', 'Quiescent', 'Inactive','Total')
    title('ST-HSCs')
    ax = gca; ax.FontSize=28; ax.LineWidth=1.5;
    %yscale log
% 
% 
% 
% 
% 
% 
% 
% 

end