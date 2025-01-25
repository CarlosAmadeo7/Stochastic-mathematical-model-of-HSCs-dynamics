# Stochastic and spatial modeling of Hematopoietic stem cells (LT-HSCs and ST-HSCs)
This repository shows my work performed during my Master's degree where I developed a MATLAB-based stochastic model of hematopoietic stem cell dynamics.
In this repository, I will show how to use the model on the "Model scripts" and how this model was constructed as well as the biological justification behind it. This model is published in "".
## Formulation
We formulated a stochastic, agent-based model to simulate the behavior of long-term (LT-HSCs) and short-term (ST-HSCs) hematopoietic stem cells, incorporating key processes such as quiescence, apoptosis, distinct modes of cell division, and eventual inactivation after reaching a maximum number of divisions. Both LT-HSCs and ST-HSCs can enter a quiescent state with distinct probabilities. While quiescent, cells may either remain dormant or stochastically undergo apoptosis. Non-quiescent cells also face a probability of apoptosis. Surviving cells can divide via four distinct modes: symmetric self-renewal, asymmetric division, direct differentiation, or symmetric differentiation. The selection of each division mode is determined stochastically through a Markov process. This division process continues until LT-HSCs and ST-HSCs reach their respective maximum division limits, at which point they transition to an inactive state. The list below lists all the parameters we can find in the model, which can be found in the setup.m script.

1. t	Time frame of the simulation.
2. NA and NB	Initial number of LT-HSCs and ST-HSCs.
3. PQA	Quiescence probability for LT-HSCs
4. PQB	Quiescence probability for ST-HSCs
5. P1A	LT-HSCs symmetrical proliferation 
6. P2A	LT-HSCs asymmetrical proliferation 
7. P3A	LT-HSCs direct differentiation 
8. P4A	LT-HSCs symmetrical differentiation 
9. P1B	ST-HSCs symmetrical proliferation 
10. P2B	ST-HSCs asymmetrical proliferation 
11. P3B	ST-HSCs direct differentiation 
12. P4B	ST-HSCs symmetrical differentiation 
13. PAA	LT-HSCs apoptosis 
14. PAB	ST-HSCs apoptosis 
15. PAQA	Quiescent LT-HSCs apoptosis 
16. PAQB	Quiescent ST-HSCs apoptosis .
17. meanCCA	LT-HSCs mean cell division time.
18. meanCCB	ST-HSCs mean cell division time.
19. stdCCA	Standard deviation of the LT-HSCs cell cycle.
20. stdCCB	Standard deviation of the ST-HSCs cell cycle.
divA	Maximum number of divisions for active LT-HSC.
divB	Maximum number of divisions for active ST-HSC.
Lx	First spatial dimension size.
Ly	Second spatial dimension size.
dtBrow	Time discretization for Brownian motion
Df	Diffusion coefficient
aQ	Gradient change of quiescent cells
aD	Gradient change of mean division time





and the Materials and Methods section provides further details, mathematical equations, and modeling assumptions.







