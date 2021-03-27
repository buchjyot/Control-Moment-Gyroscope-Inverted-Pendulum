clearVals();

% Symbolic dynamic math
[f,x,h,w,v,f_jac,L,C,M] = symbolicDynamics();

% States and simulation paramters initialization
initParmas = stateInit();

% Linearization based State Feedback control
contorllerAlgorithm(initParmas)