# Stochastic and spatial modeling of Hematopoietic stem cells (LT-HSCs and ST-HSCs)
This repository shows my work performed during my Master's degree where I developed a MATLAB-based stochastic model of hematopoietic stem cell dynamics.
In this repository, I will show how to use the model on the "Model scripts" and how this model was constructed as well as the biological justification behind it. This model is published in "".
## Formulation
We formulated a stochastic, agent-based model to simulate the behavior of long-term (LT-HSCs) and short-term (ST-HSCs) hematopoietic stem cells, incorporating key processes such as quiescence, apoptosis, distinct modes of cell division, and eventual inactivation after reaching a maximum number of divisions. Both LT-HSCs and ST-HSCs can enter a quiescent state with distinct probabilities. While quiescent, cells may either remain dormant or stochastically undergo apoptosis. Non-quiescent cells also face a probability of apoptosis. Surviving cells can divide via four distinct modes: symmetric self-renewal, asymmetric division, direct differentiation, or symmetric differentiation. The selection of each division mode is determined stochastically through a Markov process. This division process continues until LT-HSCs and ST-HSCs reach their respective maximum division limits, at which point they transition to an inactive state. The list below lists all the parameters we can find in the model, which can be found in the setup.m script.

1. t	Time frame of the simulation.
NA and NB	Initial number of LT-HSCs and ST-HSCs.
PQA	Quiescence probability for LT-HSCs
PQB	Quiescence probability for ST-HSCs
P1A	LT-HSCs symmetrical proliferation 
P2A	LT-HSCs asymmetrical proliferation 
P3A	LT-HSCs direct differentiation 
P4A	LT-HSCs symmetrical differentiation 
P1B	ST-HSCs symmetrical proliferation 
P2B	ST-HSCs asymmetrical proliferation 
P3B	ST-HSCs direct differentiation 
P4B	ST-HSCs symmetrical differentiation 
PAA	LT-HSCs apoptosis 
PAB	ST-HSCs apoptosis 
PAQA	Quiescent LT-HSCs apoptosis 
PAQB	Quiescent ST-HSCs apoptosis .
meanCCA	LT-HSCs mean cell division time.
meanCCB	ST-HSCs mean cell division time.
stdCCA	Standard deviation of the LT-HSCs cell cycle.
stdCCB	Standard deviation of the ST-HSCs cell cycle.
divA	Maximum number of divisions for active LT-HSC.
divB	Maximum number of divisions for active ST-HSC.
Lx	First spatial dimension size.
Ly	Second spatial dimension size.
dtBrow	Time discretization for Brownian motion
Df	Diffusion coefficient
aQ	Gradient change of quiescent cells
aD	Gradient change of mean division time





and the Materials and Methods section provides further details, mathematical equations, and modeling assumptions.







