function p = setupp

p = inputParser;
addParameter(p, 'PQA', 0.5);
addParameter(p, 'PQB', 0.5);

addParameter(p, 'P1A', 0.25);
addParameter(p, 'P2A', 0.25);
addParameter(p, 'P3A', 0.25);
addParameter(p, 'P4A', 0.25);

addParameter(p, 'P1B', 0.25);
addParameter(p, 'P2B', 0.25);
addParameter(p, 'P3B', 0.25);
addParameter(p, 'P4B', 0.25);

addParameter(p, 'PAA', 0);
addParameter(p, 'PAB', 0);
addParameter(p, 'PAQA', 0.0)
addParameter(p, 'PAQB', 0.0)
addParameter(p, 'meanCCA', 2);
addParameter(p, 'stdCCA', 0.5);
addParameter(p, 'meanCCB', 2);
addParameter(p, 'stdCCB', 0.5);
addParameter(p, 'meanCCC', 0);
addParameter(p, 'stdCCC', 0);
addParameter(p, 'max_divisions_A', 5);
addParameter(p, 'max_divisions_B', 5);

addParameter(p, 'Lx', 500);
addParameter(p, 'Ly', 500);
addParameter(p, 'dtBrow', 1);
addParameter(p, 'Df', 600); % addParameter(p, 'Df', 600);
addParameter(p, 'EV', -0);% addParameter(p, 'EV', -0.5);

addParameter(p, 'a', 0.75);
addParameter(p, 'a1', 0.75);


addParameter(p, 'seed', 123456789);
