% ----------------------------------------------------
% Main Routine for CMG Computation of EKF and UKF

% Author : Jyot Buch
% Copyright MathWorks Inc. 2016
%-----------------------------------------------------
% Clearing workspace
clearVals();
    
for q = 1:10    
    % Symbolic dynamic math
    [f,x,h,w,v,f_jac,L,C,M] = symbolicDynamics();
    % States and simulation paramters initialization
    initParmas = stateInit();
    % Extended Kalman - Bucy Filter
    structEKF = extendedKalmanFilter(initParmas);
    % Unscented Kalman - Bucy Filter
    structUKF = unscentedKalmanFilter(initParmas);
    % Plot the response and compare
    % getPlots(initParmas,structEKF,structUKF);
    [extendedKFRMSE,unscentedKFRMSE] = getResults(structEKF,structUKF);
    EKFR(q) = extendedKFRMSE; UKFR(q) = unscentedKFRMSE;
end

EKF_RMSE = sum(EKFR)/10;
UKF_RMSE = sum(UKFR)/10;