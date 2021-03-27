function initParams = stateInit()
%% ------------------
% Initialiization
% ------------------
disp('Computing Responses...');
initParams.nState = 6;                      %number of states
initParams.dt = 0.01;                       %ode step size
initParams.t = 0:initParams.dt:1;         %time steps
initParams.n = length(initParams.t);        %number of time steps
initParams.Q = 0.01*eye(initParams.nState); %Modelling Error or Plant Noise Covariance
initParams.R = 0.02 ;                       %Measurement Noise Covariance
initParams.P0 = eye(initParams.nState);     %initial state covraiance
initParams.u = [0 0 0];
% Global Jacobians
initParams.L = eye(6);
initParams.C = [1 0 0 0 0 0];
initParams.M = 1;
% -------------------------
% Initial guess for x and u
% -------------------------
x0(1) = pi/3;
x0(2) = 0;
x0(3) = 0;
x0(4) = 0;
x0(5) = 0;
x0(6) = 0;
initParams.x0 = x0';
% --------------------------
% Noise Init
% -------------------------
%Zero mean gaussian measurement noise data
initParams.V = sqrt(initParams.R)*randn(initParams.n,1);
initParams.W = sqrt(initParams.Q)*randn(initParams.n,6)';
% ODE options
initParams.options = odeset('AbsTol',1e-2);
end