function p = setup

p = inputParser;
addParameter(p, 'PQA', 0.60);
addParameter(p, 'PQB', 0.55);
addParameter(p, 'PQC', 1);
addParameter(p, 'P1A', 0.48);
addParameter(p, 'P2A', 0.1);
addParameter(p, 'P3A', 0.2);
addParameter(p, 'P4A', 0.22);
addParameter(p, 'P1B', 0.4);   % 0.4
addParameter(p, 'P2B', 0.1);   % 0.1
addParameter(p, 'P3B', 0.25);  % 0.25
addParameter(p, 'P4B', 0.25);  %0.25
addParameter(p, 'PAA', 0.025);
addParameter(p, 'PAB', 0.025);
addParameter(p, 'PAQA', 0.00)
addParameter(p, 'PAQB', 0.00)
addParameter(p, 'meanCCA', 5);
addParameter(p, 'stdCCA', 1.5);
addParameter(p, 'meanCCB', 3.5);  %% they have to divide more frequently than the ST-HSCs
addParameter(p, 'stdCCB', 1.5);
addParameter(p, 'meanCCC', 0);
addParameter(p, 'stdCCC', 0);
addParameter(p, 'max_divisions_A', 2);
addParameter(p, 'max_divisions_B', 3);

addParameter(p, 'Lx', 500);
addParameter(p, 'Ly', 500);
addParameter(p, 'dtBrow', 1);
addParameter(p, 'Df', 1/600); %  600  %% how fast in the space 600 is the maximum. 600 is always , 1/600 to run it 
addParameter(p, 'EV', 0);% -0.5  5 no necessary aand make simulation very slow, ev is always 

addParameter(p, 'aQ', 1); % for change of quiescence in space (==1 no change)
addParameter(p, 'aD', 1); % for change in division rate in space (==1 no change)


