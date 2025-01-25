# Stochastic and spatial modeling of Hematopoietic stem cells (LT-HSCs and ST-HSCs)
This repository shows my work performed during my Master's degree where I developed a MATLAB-based stochastic model of hematopoietic stem cell dynamics.
In this repository, I will show how to use the model on the "Model scripts" and how this model was constructed as well as the biological justification behind it. This model is published in "".
## Formulation
We formulated a **stochastic, agent-based model to simulate the behavior of long-term (LT-HSCs) and short-term (ST-HSCs) hematopoietic stem cells**, incorporating key processes such as quiescence, apoptosis, distinct modes of cell division, and eventual inactivation after reaching a maximum number of divisions. Both LT-HSCs and ST-HSCs can enter a quiescent state with distinct probabilities.
While quiescent, cells may either remain dormant or stochastically undergo apoptosis. Non-quiescent cells also face a probability of apoptosis. 
Surviving cells can divide via four distinct modes: symmetric self-renewal, asymmetric division, direct differentiation, or symmetric differentiation. 
The selection of each division mode is determined stochastically through a Markov process. This division process continues until LT-HSCs and ST-HSCs reach their respective maximum division limits, at which point they transition to an inactive state. The list below of all the parameters we can find in the model as well as their respective descriptions can be found in the **README.txt** associated with this repository. In addition, the set of parameters can be found in the **setup.m** script.

## Usage
Main model 
Multiple seeds
Visualization
Spatial model 
PRCC analysis 

```matlab
% Example MATLAB Code
function y = exampleFunction(x)
    y = x^2 + 5;
    disp(y);
end

Main model 
Multiple seeds
Visualization
Spatial model 
PRCC analysis 










