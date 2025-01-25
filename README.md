# Stochastic and spatial modeling of Hematopoietic stem cells (LT-HSCs and ST-HSCs)
This repository shows my work performed during my Master's degree where I developed a MATLAB-based stochastic model of hematopoietic stem cell dynamics.
In this repository, I will show how to use the model on the "Model scripts" and how this model was constructed as well as the biological justification behind it. This model is published in "".
## Formulation
We formulated a **stochastic, agent-based model to simulate the behavior of long-term (LT-HSCs) and short-term (ST-HSCs) hematopoietic stem cells**, incorporating key processes such as quiescence, apoptosis, distinct modes of cell division, and eventual inactivation after reaching a maximum number of divisions. Both LT-HSCs and ST-HSCs can enter a quiescent state with distinct probabilities.
While quiescent, cells may either remain dormant or stochastically undergo apoptosis. Non-quiescent cells also face a probability of apoptosis. 
Surviving cells can divide via four distinct modes: symmetric self-renewal, asymmetric division, direct differentiation, or symmetric differentiation. 
The selection of each division mode is determined stochastically through a Markov process. This division process continues until LT-HSCs and ST-HSCs reach their respective maximum division limits, at which point they transition to an inactive state. The list below of all the parameters we can find in the model as well as their respective descriptions can be found in the **README.txt** associated with this repository. In addition, the set of parameters can be found in the **setup.m** script.

## Usage
### Main model
The model is located in the file **Model_scripts**. Download that file and open it using MATLAB. 
Out of those files, the **cellmodel_diff_spaQD.m** integrates all the functions and runs the main model based on the parameter setup **setup.m** you established.
After setting up the parameters and time, open the **cellmodel_diff_spaQD.m** and run this command on the command window:
```matlab
[cellstypeA, cellstypeB, cellstypeC, params] = cellmodel_diff_spaQD;
```
**This command will display the total number of LT-HSCs and ST-HSCs per time-step, as well as the number of active, inactive, and quiescent cells**. In addition, the coordinates of the spatial configuration are recorded per time step.
In addition, it will display all the types of cells in a 2-D dimensional space where the y-axis is the counts and the x-axis is time.
An example of a visualization plot is displayed below, where the model was run for 80 steps and just one single seed. Both LT-HSCs and ST-HSCs are displayed:

<img src="https://github.com/user-attachments/assets/ede33970-9ecc-4b18-b577-9fe49eea534c" alt="LT-HSC single run" width="335"/>
<img src="https://github.com/user-attachments/assets/9c09a66c-296a-4ff9-abdb-b9255fe5fab8" alt="ST-HSC single run" width="320"/>

While the model runs a single seed at a time, to test for stochasticity we need to run for multiple seeds. 
When running for a long period this process can be overwhelming computationally. To solve this we can run for multiple seeds in a HPC cluster. 
The file **RunInServer.m** in the **Model_scripts** folder of this repository is a function that takes the model and runs it for 30 different seeds, saving the total number of LT-HSCs and ST-HSCs per time step.
The **RunInServer.m** file can be run via the command line or by submitting a Bash script. An example of a Bash Script using the **RunInServer.m**, 16 threads, and SLURM can be found below:

```bash
#!/bin/sh
#SBATCH --job-name=validation
#SBATCH -n 16
#SBATCH -N 1
#SBATCH --output job_%j_%N.out
#SBATCH --error job_%j_%N.err
#SBATCH -p defq-48core

# Print this sub-job's task ID
echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

# Loading module matlab
module load matlab/R2020a 
# Directory of files from the model 
cd /work/alfaroqc/Model_validation
# Running the script 
matlab -nodisplay -nosplash -r  "RunInServer($SLURM_ARRAY_TASK_ID), exit "
```
This bash script runs like an array and then generates a data file for each seed. Then, to visualize the multiple-seed data we created a MATLAB script that takes the files and then calculates the mean and standard deviation.
The script can be found in the **Plotting_folder** and can be run using the command below:
```matlab
Plot_allruns_types_spread(namefolder);
```
Where **namefolder** is the folder where all the data from each seed is located 
An example of a visualization generated for multiple seeds is shown below for both LT-HSCs and ST-HSCs:


<div style="display: flex; justify-content: space-around; align-items: center;">
  
<img src="Figures/LT-HSCs_multiple_seeds.svg" alt="LT-HSC quiescent plot" width="400"/>
<img src="Figures/ST-HSCs_multiple_seeds.svg" alt="LT-HSC quiescent plot" width="400"/>

</div>

### Spatial component of the model 
The stochastic component of the model allows the exploration of the HSCs dynamics in a 2-D spatial domain that mimics the bone marrow environment. 
The parameters related to the spatial component can be found in the **README.txt**.
The function **plotdensity1.m** plots the coordinates of LT-HSCs and ST-HSCs at a specific time frame, this will be displayed as a normalized value by the total number of LT-HSCs and ST-HSCs at that time step.
Two components of the model control the gradient of change:
1. aQ ( gradient of change in quiescent state)
2. aD ( gradient of change in the mean division)

To run the **plotdensity1.m** you pick a frame (example: 80) and then run the command:
```matlab
plotdensity1(xyA, celltypeA, celltypeB, 80);
```

This function will display a heatmap like the one below, where aQ and aD were set up at 0.25, and we set the function to display the Active LT-HSCs:

<img src="https://github.com/user-attachments/assets/f2d56383-1e78-4b44-bd6a-16bb26dac7bd" alt="Active_LT-HSC" width="400"/>

### Partial Rank Coefficient Analysis
PRCC analysis is 
PRCC analysis is a statistical method used to assess the sensitivity of a model's output to changes in its input parameters, essentially identifying which parameters have the most significant impact on the model's results, especially when dealing with complex systems with many interacting variables. 
Our PRCC analysis contains an LHS component given by this equation: *n  ≥  k+1 or  n  ≥  k*4/3* where  *k* is the number of parameters included in the LHS. 
In this repository in the **PRCC folder**, we can find the code associated with running the PRCC analysis and the data containing 10337 LHS combinations: **dataPRCC_ab_all.mat**.
To generate the PRCC results as bar graphs we need to run the **CalcPRCC_PAV_with_zscores.m** that takes all the combinations, sorts the parameters, and gives a PRCC value according their positive or negative influence. More details can be found in the code as well as the **README.txt** associated with this repository.
To run the code you type this in the command window of MATLAB:
``` matlab
CalcPRCC_PAV_with_zscores(params, output, titleplot);
```
Where:
1. **params** are the parameters found in each column of the **dataPRCC_ab_all.mat**. The input in the function would be: *dataPRCC(:,1:16)*. The parameters are distributed in 46 columns
2. **output** is the ouput which is the last column of the **dataPRCC_ab_all.mat**. The input in the function would be: *dataPRCCval_a(:,3)* if you want to see the influence on the **Active LT-HSCs**
3. **titleplot** is the title of the plot.
   
### License
MIT











