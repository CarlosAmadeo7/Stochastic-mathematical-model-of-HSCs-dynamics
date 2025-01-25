function Plot_allruns_types_spread(namefolder)

% Create a separate folder with the files you want to plot
% The namefolder variable is the name of the folder you want to analyze
% for example: 'Test1'

% this commnand find all the files with extension '.mat' and save their
% names
  names = dir([namefolder '/*.mat']);

% Sizes
  data = load([namefolder '/' names(1).name]);
  m1 = length(names);
  m2 = length(data.cellstypeA.Num);
  
% Pre-allocate memory
  totaltypeA    = zeros(m1,m2);
  activetypeA   = zeros(m1,m2);
  inactivetypeA = zeros(m1,m2);
  QuiesctypeA   = zeros(m1,m2);
  totaltypeB    = zeros(m1,m2);
  activetypeB   = zeros(m1,m2);
  inactivetypeB = zeros(m1,m2);
  QuiesctypeB   = zeros(m1,m2);
     

% Loop through each of those files  
  for k = 1:length(names)

      data = load([namefolder '/' names(k).name]);
      totaltypeA(k,:)    = data.cellstypeA.Num+data.cellstypeA.NumI+data.cellstypeA.NumQ;
      activetypeA(k,:)   = data.cellstypeA.Num;
      inactivetypeA(k,:) = data.cellstypeA.NumI;
      QuiesctypeA(k,:)   = data.cellstypeA.NumQ;

      totaltypeB(k,:)    = data.cellstypeB.Num+data.cellstypeB.NumI+data.cellstypeB.NumQ;
      activetypeB(k,:)   = data.cellstypeB.Num;
      inactivetypeB(k,:) = data.cellstypeB.NumI;
      QuiesctypeB(k,:)   = data.cellstypeB.NumQ;
  end

      time = 1:m2;

   %% plot type A  
    % Create Figure 

      figure('Position',[100,500,900,700]);
      set(gca, 'YScale', 'log');
      ylim([10^3, 10^6]);
      hold on
      plot(time, mean(totaltypeA),'k','LineWidth',3)
      plot(time, mean(activetypeA),'--','color',[0.00,0.45,0.74],'LineWidth',3)
      plot(time, mean(inactivetypeA),'-.','color',[0.85,0.33,0.10],'LineWidth',3)
      plot(time, mean(QuiesctypeA),'color',[0.47,0.67,0.19],'LineWidth',3)

      plot(time, totaltypeA,'color',[0.8 0.8 0.8],'LineWidth',1)
      plot(time, activetypeA,'color',[0.78,0.90,0.97],'LineWidth',1)
      plot(time, inactivetypeA,'color',[0.94,0.88,0.85],'LineWidth',1)
      plot(time, QuiesctypeA,'color',[0.82,0.87,0.73],'LineWidth',3)

      mtA = mean(totaltypeA);    stA = std(totaltypeA);
      maA = mean(activetypeA);   saA = std(activetypeA);
      miA = mean(inactivetypeA); siA = std(inactivetypeA);
      mQA = mean(QuiesctypeA);   sQA = std(QuiesctypeA);
      errorbar(time(1:6:end), mtA(1:6:end), stA(1:6:end), 'k','LineWidth',1)
      errorbar(time(1:6:end), maA(1:6:end), saA(1:6:end),'--','color',[0.00,0.45,0.74],'LineWidth',1)
      errorbar(time(1:6:end), miA(1:6:end), siA(1:6:end),'-.','color',[0.85,0.33,0.10],'LineWidth',1)
      errorbar(time(1:6:end), mQA(1:6:end), sQA(1:6:end),'color',[0.47,0.67,0.19],'LineWidth',1)
      %errorbar(kt(:,1), kt(:,2), s, 's', 'MarkerSize', 10, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'w')
      
      ax = gca;
      ax.LineWidth=2;
      ax.FontSize=28;
      title('LT-HSCs')
      legend('total', 'active', 'inactive', 'quiescent')


   %% plot type B
      figure('Position',[100,500,900,700]);
      set(gca, 'YScale', 'log');
      hold on   
      plot(time, mean(totaltypeB),'k','LineWidth',3)
      plot(time, mean(activetypeB),'--','color',[0.00,0.45,0.74],'LineWidth',3)
      plot(time, mean(inactivetypeB),'-.','color',[0.85,0.33,0.10],'LineWidth',3)
      plot(time, mean(QuiesctypeB),'color',[0.47,0.67,0.19],'LineWidth',3)
      
      plot(time, totaltypeB,'color',[0.8 0.8 0.8],'LineWidth',1)
      plot(time, activetypeB,'color',[0.78,0.90,0.97],'LineWidth',1)
      plot(time, inactivetypeB,'color',[0.94,0.88,0.85],'LineWidth',1)
      plot(time, QuiesctypeB,'color',[0.82,0.87,0.73],'LineWidth',3)

      mtB = mean(totaltypeB);    stB = std(totaltypeB);
      maB = mean(activetypeB);   saB = std(activetypeB);
      miB = mean(inactivetypeB); siB = std(inactivetypeB);
      mQB = mean(QuiesctypeB);   sQB = std(QuiesctypeB);
      errorbar(time(1:6:end), mtB(1:6:end), stB(1:6:end), 'k','LineWidth',1)
      errorbar(time(1:6:end), maB(1:6:end), saB(1:6:end),'--','color',[0.00,0.45,0.74],'LineWidth',1)
      errorbar(time(1:6:end), miB(1:6:end), siB(1:6:end),'-.','color',[0.85,0.33,0.10],'LineWidth',1)
      errorbar(time(1:6:end), mQB(1:6:end), sQB(1:6:end),'color',[0.47,0.67,0.19],'LineWidth',1)
      ax = gca;
      ax.LineWidth=2;
      ax.FontSize=28;
      title('ST-HSCs')
      legend('total', 'active', 'inactive', 'quiescent')
   
      

  end

