Hello!
You are reading the documentation on how to use the Stochastic Mathematical model in this repository.

This model was designed to explore the stochastic and spatial dynamics of long-term (LT-HSCs)and short-term HSCs (ST-HSCs).
Here you will some information regarding the content of the scripts in this repository and how to use it. For more details and justification of how these scripts were constructed, refer to the repository and to the paper: "Stochastic modeling of hematopoietic stem cell dynamics".

##################################################################################################################################################
1. Model_scripts:
This folder contains all the scripts necessary to run the MATLAB-based model. Each one of the scripts is designed to perform a characteristic of HSCs. 

apoptosis.m: Script controlling the apoptosis decision of the cells per time step.
asymdiv.m: Script controlling the asymmetrical division (1A-->1A + 1B) decision of the cells during the simulation.
cellmodel_diff_spaQD.m:  Main script that runs the simulation.
diff2dEV_cells.m: Set up spatial parameters.
inactivecells.m: Controls the threshold of inactivity of the cells.
initializervar.m: Initialize the variables.
onediff.m:  Script controlling the direct differentiation (1A-->1B) decision of the cells during the simulation.
plotdensity.m:  Plot the density of cells at a specific frame.
plotdensity1.m: Plot the density of cells at multiple frames.
RunInServer.m:  Script to run the model into a cluster server to speed up the process when using various seeds.
setup.m: Main script to set up the parameters.
setupconstants.m: Set up the constants into the model.
symdiv.m:  Script controlling the symmetrical division/proliferation (1A-->2A) decision of the cells during the simulation.
twodiff.m: Script controlling the symmetrical differentiation (1A-->2B) decision of the cells during the simulation.

The whole model is based on different parameters listed in the repository as well as in the setup script. 
To run the model, download this folder, open MATLAB, set up the parameters and constants and run this command:

[cellstypeA, cellstypeB, cellstypeC, params] = cellmodel_diff_spaQD;

This command will display and record the number of LT-HSCs, ST-HSCs per time step, their position in space per time step as well as their population distribution as a plot.
If you want to display the position of the cells, you can use the plotdensity.m or plotdensity1.m as follows:

plotdensity(xy,numcells,frame);

Where:
. xy is the 2D coordinates of the cells
. numcells is the type of cells
. frame is the single-time step you want to display 

Example:
plotdensity(xyA,numcellsA,40);

. This will extract the coordinates of the cellstypeA, as well as the cellstypeA.Num, that corresponds to the number of cells per time step. Then it will display their position at time 40.

##################################################################################################################################################
2. PRCC
This folder contains a script that is used to display the PRCC values of active, quiescent, and inactive LT-HSCs. 
The data in this repository contain 10337 combinations of parameters for model validation. this script calculates the PRCC values of each parameter and weights them based on influence on the three outputs. 
Then it calculates the z-score based on: √((n-2)/(1-ρ^2 )), and their p-value based on p-value =2(1-Φ(|z|)). The script displays each parameter and its corresponding PRCC value as a bar plot.
To use this script load the data in this repository: datapRCC_ab_all.m (16 input parameters) and run the script:

CalcPRCC_PAV_with_zscores(params, output, titleplot);

. where params is the 16 inputs from the datapRCC_ab_all.m
. output is the type of cell :

   dataPRCCval_a(:,3)-> Active LT-HSCs
   dataPRCCval_a(:,2)-> Inactive LT-HSCs
   dataPRCCval_a(:,1)-> Quiescent LT-HSCs
   dataPRCCval_b(:,3)-> Active ST-HSCs
   dataPRCCval_b(:,2)-> Inactive ST-HSCs
   dataPRCCval_b(:,1)-> Quiescent ST-HSCs
. and titleplot is the title of the plot

Example:
CalcPRCC_PAV_with_zscores(dataPRCC(:,1:16), dataPRCCval_a(:,3),'Active A')

##################################################################################################################################################
3. Parameters
The parameters associated with the script model can be found below, in addition, they can be found in the script "setup.m" where they can be modified to explore multiple theoretical scenarios.
1. t:	Time frame of the simulation.
2. NA and NB:	Initial number of LT-HSCs and ST-HSCs.
3. PQA:	Quiescence probability for LT-HSCs
4. PQB:	Quiescence probability for ST-HSCs
5. P1A:	LT-HSCs symmetrical proliferation 
6. P2A:	LT-HSCs asymmetrical proliferation 
7. P3A:	LT-HSCs direct differentiation 
8. P4A:	LT-HSCs symmetrical differentiation 
9. P1B:	ST-HSCs symmetrical proliferation 
10. P2B:	ST-HSCs asymmetrical proliferation 
11. P3B:	ST-HSCs direct differentiation 
12. P4B:	ST-HSCs symmetrical differentiation 
13. PAA:	LT-HSCs apoptosis 
14. PAB: ST-HSCs apoptosis 
15. PAQA:	Quiescent LT-HSCs apoptosis 
16. PAQB:	Quiescent ST-HSCs apoptosis.
17. meanCCA:	LT-HSCs mean cell division time.
18. meanCCB:	ST-HSCs mean cell division time.
19. stdCCA:	Standard deviation of the LT-HSCs cell cycle.
20. stdCCB:	Standard deviation of the ST-HSCs cell cycle.
21. divA:	Maximum number of divisions for active LT-HSC.
22. divB:	Maximum number of divisions for active ST-HSC.
23. Lx:	First spatial dimension size.
24. Ly:	Second spatial dimension size.
25. dtBrow:	Time discretization for Brownian motion
26. Df:	Diffusion coefficient
27. aQ:	Gradient change of quiescent cells
28. aD:	Gradient change of mean division time






