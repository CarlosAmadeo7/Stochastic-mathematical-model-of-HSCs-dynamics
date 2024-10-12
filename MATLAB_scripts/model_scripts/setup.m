function p = setup

p = inputParser;
addParameter(p, 'PQA', 0.5);
addParameter(p, 'PQB', 0.5);
addParameter(p, 'PQC', 1);

addParameter(p, 'P1A', 0.25);
addParameter(p, 'P2A', 0.25);
addParameter(p, 'P3A', 0.25);
addParameter(p, 'P4A', 0.25);

addParameter(p, 'P1B', 0.25);
addParameter(p, 'P2B', 0.25);
addParameter(p, 'P3B', 0.25);
addParameter(p, 'P4B', 0.25);

addParameter(p, 'PAA', 0.0);
addParameter(p, 'PAB', 0.00);

addParameter(p, 'PAQA', 0.01)
addParameter(p, 'PAQB', 0.01)

addParameter(p, 'meanCCA', 1);
addParameter(p, 'stdCCA', 1.5);

addParameter(p, 'meanCCB', 1);
addParameter(p, 'stdCCB', 0.5);

addParameter(p, 'meanCCC', 0);
addParameter(p, 'stdCCC', 0);
addParameter(p, 'max_divisions_A', 5);
addParameter(p, 'max_divisions_B', 5);


% Spatial 
addParameter(p, 'Lx', 500); %% do not change 
addParameter(p, 'Ly', 500); %% do not change
addParameter(p, 'dtBrow', 1);
addParameter(p, 'Df', 600); %  600
addParameter(p, 'EV', -0);% -0.5  5 no necessary aand make simulation very slow

addParameter(p, 'aQ', 0.5); % for change of quiescence in space (==1 no change) 0.5
addParameter(p, 'aD', 0.5); % for change in division rate in space (==1 no change) 0.5
