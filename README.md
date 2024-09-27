This branch contains separate MATLAB files that describe the different functions of the computational model.
While this branch shows a very flexible model, its reproducibility is still under construction. The validated model can be found in the main branch of this repository.

1. apopQuiec = This function controls the apoptosis of Quiescent cells in the model.
2. apoptosis = This function controls the apoptosis of Active cells in the model.
3. asymdiv =  This function controls the asymmetrical division of both populations when 1 A cell--> 1 A cell + 1 B cell.
4. diffone =  This function controls the direct differentiation of both populations when 1 A cell--> 1 B cell.
5. difftwo =  This function controls the double differentiation of both populations when 1 A cell--> 2 B cell.
6. inactive cells =  This function makes the cells stop once they have reached their maximum number of divisions.
7. initializevar=   Initialize the variables for the population and spatial model.
8. quiescence =   It controls the percentage of cells that go quiescence based on probability.
9. setupconstants=   = Constant parametrization.
10. setup=   File to SETUP the constants
11. symdiv =  This function controls the symmetrical division of both populations when 1 A cell--> 2 A cells.
12. cellmodel_diff_v4 = The model itself, joins all the files and gives you a population of A and B cells on a time frame (Nt), as well as the distribution of cells in space during the same time frame.

To initialize the model, open all the files in a MATLAB folder using the command window put the following command:
[cellstypeA, cellstypeB, cellstypeC, params] = cellmodel_diff_v4();
    
