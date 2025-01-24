function [PQA, PQB, PQC, P1A, P2A, P3A, P4A, P1B, P2B, P3B, P4B, PAA, PAB, PAQA, PAQB,...
    meanCCA, stdCCA, meanCCB, stdCCB, meanCCC, stdCCC, max_divisions_A, max_divisions_B,...
    Lx, Ly, dtBrow, Df, EV, aQ, aD] = setupconst(p)

PQA = p.Results.PQA;
PQB = p.Results.PQB;
PQC = p.Results.PQC;
P1A = p.Results.P1A;
P2A = p.Results.P2A;
P3A = p.Results.P3A;
P4A = p.Results.P4A;
P1B = p.Results.P1B;
P2B = p.Results.P2B;
P3B = p.Results.P3B;
P4B = p.Results.P4B;
PAA = p.Results.PAA;
PAB = p.Results.PAB;
PAQA = p.Results.PAQA;
PAQB = p.Results.PAQB;
meanCCA = p.Results.meanCCA;
stdCCA = p.Results.stdCCA;
meanCCB = p.Results.meanCCB;
stdCCB = p.Results.stdCCB;
meanCCC = p.Results.meanCCC;
stdCCC = p.Results.stdCCC;
max_divisions_A = p.Results.max_divisions_A;
max_divisions_B = p.Results.max_divisions_B;


Lx     = p.Results.Lx;
Ly     = p.Results.Ly;
dtBrow = p.Results.dtBrow;
Df     = p.Results.Df;
EV     = p.Results.EV;
aQ     = p.Results.aQ;
aD     = p.Results.aD;

