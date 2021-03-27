%% Main Routine for Unscented Kalman Filter
function structUKF = unscentedKalmanFilter(params)

%params.dt = 0.01;
%params.t = 0:params.dt:1;

%local Parametes
Q = params.Q;
R = params.R;
x0 = params.x0;
P0 = params.P0;
dt = params.dt;
t = params.t;
options = params.options;
u = params.u;
L = params.L;
C = params.C;
M = params.M;

% Initialization
Xact(1,:) = x0';
Xest(1,:) = x0';           %First Estimated state = initial condition
P(:,:,1) = P0;

% Pre allocating memory to avoid mlint errors and support code-generation
G = zeros(length(t),6);
Yact = zeros(length(t),1);
Yest = zeros(length(t),1);

Qt = L*Q*L';
Rt = M*R*M';
disp('Entering in UKF loop...');
for i = 1:length(t)
    [A,B] = getDerivative(Xest(i,:),u(i,:));
    Yest(i) = C*Xest(i,:)';
    [Xest(i+1,:),Pp] = unsecntedKFPredict(Xest(i,:),u(i,:),P(:,:,i),Qt,dt,options);
    [G(i,:),Xest(i+1,:),P(:,:,i+1)] = unscentedKFCorrect(Xest(i+1,:),Yest(i),Pp,Rt);
    [Xact(i+1,:),Yact(i)] = actualTrajac(u(i,:),C,Xact(i,:),dt,options);
    E = eig((A - G(i,:)'*C))./10;
    index = find(round(E(:)==0));
    if(numel(index) == 2)              % if there are 2 eigen values which are zero
        E(index(1)) = -0.01 + 0.0707i;   % complex conjugate eigen values
        E(index(2)) = -0.01 - 0.0707i;
    elseif(numel(index) == 1)          % if there is 1 eigen value which is zero
        E(index(1)) = -0.01;            % negentive real values
    end
    K = place(A,B,E);
    u(i+1,:) = - K * Xest(i+1,:)';
    fprintf('UKF Iteration: %d \n',i);
end

% return structure
structUKF.G = G;
structUKF.P = P;
structUKF.Xest = Xest;
structUKF.Yest = Yest;
structUKF.Xact = Xact;
structUKF.Yact = Yact;
structUKF.u = u;
end

%% Predict Step / Time Update
function [xbarp,Pp] = unsecntedKFPredict(xbar,u,P,Qt,dt,options)

xbar = xbar';

% Compute Sigma Points
[Wm,W,c] = getWeights(size(xbar,1));
X = getSigmaPoints(xbar,P,c);

% Propogate each sigma points through function f
for i = 1:length(X)
    [~,Xodep] = ode15s(@(t,X)getStates(X,u),[0 dt],X(:,i),options);
    Xhatp(i,:) = Xodep(end,:);%#ok
end

% Compute Predicted mean xbarp
xbarp = Xhatp' * Wm;

% Compute Predicted Covariances
Pp = Xhatp' * W * Xhatp + Qt;
end

%% Correct or Update Step / Measurement Update
function [G,xbar_r,Pp_r] = unscentedKFCorrect(xbarp,y,Pp,Rt)
xbarp = xbarp';

% Compute Sigma Points
[Wm,W,c] = getWeights(size(xbarp,1));
Xp = getSigmaPoints(xbarp,Pp,c);

% Propogate sigma points through function y = h(x) = x1
Yhat = Xp(1,:);

% Compute the Predicted mean
mu = Yhat * Wm;

% Compute the Predicted Covariances of measurement
Pyy = Yhat * W * Yhat' + Rt;

% Compute cross-covarince of the state and measurment
Pxy = Xp * W * Yhat' ;

% Compute Kalman Gain
G = Pxy/Pyy;

% Compute Filtered state mean and covariances
xbar_r = xbarp + G * (y - mu);
Pp_r = Pp - G * Pyy * G';
end

%% Calculate Sigma Points
function SP = getSigmaPoints(X,P0,c)
A = sqrtm(P0)'; % Square root of Pk-1
SP = [zeros(size(X)) A -A];
SP = sqrt(c)*SP + repmat(X,1,size(SP,2));
end

%% Calculates the weight for Sigma Points
function [WM,W,c] = getWeights(L)
% L is dimention of the problem
alpha = 1;
beta = 2;
kappa = 0;

% Compute the normal weights
lambda = alpha^2 * (L + kappa) - L;
WM = zeros(2*L+1,1);
WC = zeros(2*L+1,1);
for j=1:2*L+1
    if j==1
        wm = lambda / (L + lambda);
        wc = lambda / (L + lambda) + (1 - alpha^2 + beta);
    else
        wm = 1 / (2 * (L + lambda));
        wc = wm;
    end
    WM(j) = wm;
    WC(j) = wc;
end
c = L + lambda;
W = eye(length(WC)) - repmat(WM,1,length(WM));
W = W * diag(WC) * W';
end

%% Get Actual states and model response without noise & observer
function [Xactp, Yact] = actualTrajac(u,C,X0act,dt,options)
[~,stateActX] = ode15s(@(t,X)getStates(X,u),[0 dt],X0act,options);
Xactp = stateActX(end,:); % Predicted actual state;
Yact = C*X0act'; % Current acutal value
end

%% Solving State space for various cases
function dxdt = getStates(x,u)

% CMG Model Diffrential equation for Actual states trajectory (No noise, No estimation)
dxdt = [x(2);
    -(1.0*(63783.650733544796451948514004471*sin(x(1)) - 7.3916*u(1) - 558.48933867999998453797161346301*x(4)^2*sin(x(3)) + 1660.6750739112000403937088321982*cos(x(1))*sin(x(3)) - 16975.502565348599942932066107915*cos(x(3))^2*sin(x(1)) + 75.557299999999997908162185922265*u(2)*cos(x(3)) + 7.3916*u(3)*cos(x(3)) + 50.78546612*x(4)*x(6)*sin(x(3)) + 511.73448143999998583240085281432*x(2)^2*cos(x(3))^2*sin(x(3)) + 150.90912308*x(2)*x(4)*cos(x(3))*sin(x(3)) - 519.13154110999998562760993081611*x(2)*x(6)*cos(x(3))*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536);
    x(4);
    (2694.6*u(2) - 6.8707*u(2)*cos(x(3))^2 + 75.557299999999997908162185922265*u(3)*cos(x(3))^2 + 6.7728*u(2)*sin(x(3))^2 + 46602.275476019330955255846311048*cos(x(3))*sin(x(1)) + 1543.644167747400037547087947587*cos(x(3))^3*sin(x(1)) - 75.557299999999997908162185922265*u(1)*cos(x(3)) + 16975.502565348599942932066107915*cos(x(1))*cos(x(3))*sin(x(3)) - 18513.78822*x(2)*x(6)*sin(x(3)) + 45.87081984*x(2)^2*cos(x(3))*sin(x(3))^3 - 46.53387696*x(2)^2*cos(x(3))^3*sin(x(3)) - 1521.6489177696000370120827938081*cos(x(3))*sin(x(1))*sin(x(3))^2 - 46.53387696*x(2)*x(6)*sin(x(3))^3 + 18249.98688*x(2)^2*cos(x(3))*sin(x(3)) - 5708.9055832899996838927654607687*x(4)^2*cos(x(3))*sin(x(3)) + 519.13154110999998562760993081611*x(4)*x(6)*cos(x(3))*sin(x(3)) + 1542.6005039899999572924116364447*x(2)*x(4)*cos(x(3))^2*sin(x(3)) + 47.20651849*x(2)*x(6)*cos(x(3))^2*sin(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536);
    x(6);
    (0.14554557759762469617360676495845*(19917.40536*u(3) + 519.13154110999998562760993081611*u(2)*cos(x(3))^2 - 5708.9055832899996838927654607687*u(3)*cos(x(3))^2 + 50.06182848*u(3)*sin(x(3))^2 + 438238.32909496623298240265517052*cos(x(3))*sin(x(1)) - 116633.58547574062562790334660765*cos(x(3))^3*sin(x(1)) - 50.78546612*u(1)*cos(x(3)) + 11410.000230321682117533055273384*cos(x(1))*cos(x(3))*sin(x(3)) + 136846.517006952*x(2)*x(4)*sin(x(3)) + 3515.9741016298079026586765394313*x(2)^2*cos(x(3))^3*sin(x(3)) + 343.959804937536*x(2)*x(4)*sin(x(3))^3 - 3837.2126992686758937650415646203*x(4)^2*cos(x(3))*sin(x(3)) + 348.931702070684*x(4)*x(6)*cos(x(3))*sin(x(3)) - 38536.257981235528828122023651304*x(2)*x(4)*cos(x(3))^2*sin(x(3)) - 3566.7970795044769012516195516582*x(2)*x(6)*cos(x(3))^2*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536);
    ];
end

%% Jacobians evaluated at current state estimate
function [A_eval,B_eval] = getDerivative(x_est,u)
x = x_est;
A_eval =...
    [                                                                                                                                                                                                                                                                                                                                                                                                                     0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    1,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     0,                                                                                                                                                                                                                               0, 0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                      0;
    (16975.502565348599942932066107915*cos(x(1))*cos(x(3))^2)/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (7.3916*(8629.2075779999995199887052876875*cos(x(1)) - 224.67058200000000546481260244036*sin(x(1))*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536),                                                                                      (75.557299999999997908162185922265*cos(x(3))*(6.8707*x(6)*sin(x(3)) - 13.5456*x(2)*cos(x(3))*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (100.12365696*x(4)*cos(x(3))*sin(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (50.78546612*x(6)*cos(x(3))*sin(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             (7.3916*sin(x(3))*(u(3) + 6.8707*x(2)*x(6)*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (75.557299999999997908162185922265*cos(x(3))*(224.67058200000000546481260244036*sin(x(1))*sin(x(3)) + 6.7728*x(2)^2*cos(x(3))^2 - 6.7728*x(2)^2*sin(x(3))^2 - 6.8707*x(2)*x(6)*cos(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (7.3916*(224.67058200000000546481260244036*cos(x(1))*cos(x(3)) - 75.557299999999997908162185922265*x(4)^2*cos(x(3)) + 6.8707*x(4)*x(6)*cos(x(3)) + 13.5456*x(2)*x(4)*cos(x(3))^2 - 13.5456*x(2)*x(4)*sin(x(3))^2))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) + (75.557299999999997908162185922265*sin(x(3))*(6.7728*cos(x(3))*sin(x(3))*x(2)^2 - 6.8707*x(6)*sin(x(3))*x(2) + u(2) - 224.67058200000000546481260244036*cos(x(3))*sin(x(1))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) + (85886.738744423443326923530359636*cos(x(3))^2*sin(x(3))*(u(3) + 6.8707*x(2)*x(6)*sin(x(3))))/(- 5759.6910494099996838927654607687*cos(x(3))^2 + 50.06182848*sin(x(3))^2 + 19917.40536)^2 + (877938.48224119612192546017466339*cos(x(3))^2*sin(x(3))*(6.7728*cos(x(3))*sin(x(3))*x(2)^2 - 6.8707*x(6)*sin(x(3))*x(2) + u(2) - 224.67058200000000546481260244036*cos(x(3))*sin(x(1))))/(- 5759.6910494099996838927654607687*cos(x(3))^2 + 50.06182848*sin(x(3))^2 + 19917.40536)^2 + (85886.738744423443326923530359636*cos(x(3))*sin(x(3))*(8629.2075779999995199887052876875*sin(x(1)) - 1.0*u(1) - 75.557299999999997908162185922265*x(4)^2*sin(x(3)) + 224.67058200000000546481260244036*cos(x(1))*sin(x(3)) + 6.8707*x(4)*x(6)*sin(x(3)) + 13.5456*x(2)*x(4)*cos(x(3))*sin(x(3))))/(- 5759.6910494099996838927654607687*cos(x(3))^2 + 50.06182848*sin(x(3))^2 + 19917.40536)^2 - (50.78546612*x(2)*x(6)*cos(x(3))^2)/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536),                                   -(7.3916*(6.8707*x(6)*sin(x(3)) - 151.11459999999999581632437184453*x(4)*sin(x(3)) + 13.5456*x(2)*cos(x(3))*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536), 0,                                                                                                                                                                                                                   (468.34607498999998562760993081611*x(2)*cos(x(3))*sin(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (50.78546612*x(4)*sin(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536);
    0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     0,                                                                                                                                                                                                                               1, 0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                           0;
    (75.557299999999997908162185922265*cos(x(3))*(8629.2075779999995199887052876875*cos(x(1)) - 224.67058200000000546481260244036*sin(x(1))*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (224.67058200000000546481260244036*cos(x(1))*cos(x(3))*(6.7728*sin(x(3))^2 - 6.8707*cos(x(3))^2 + 2694.6))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536),                                  (1023.4689628799999716648017056286*x(4)*cos(x(3))^2*sin(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - ((6.8707*x(6)*sin(x(3)) - 13.5456*x(2)*cos(x(3))*sin(x(3)))*(6.7728*sin(x(3))^2 - 6.8707*cos(x(3))^2 + 2694.6))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) + (519.13154110999998562760993081611*x(6)*cos(x(3))^2*sin(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536),                                                                                             (75.557299999999997908162185922265*cos(x(3))*(224.67058200000000546481260244036*cos(x(1))*cos(x(3)) - 75.557299999999997908162185922265*x(4)^2*cos(x(3)) + 6.8707*x(4)*x(6)*cos(x(3)) + 13.5456*x(2)*x(4)*cos(x(3))^2 - 13.5456*x(2)*x(4)*sin(x(3))^2))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (75.557299999999997908162185922265*sin(x(3))*(8629.2075779999995199887052876875*sin(x(1)) - 1.0*u(1) - 75.557299999999997908162185922265*x(4)^2*sin(x(3)) + 224.67058200000000546481260244036*cos(x(1))*sin(x(3)) + 6.8707*x(4)*x(6)*sin(x(3)) + 13.5456*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) + ((6.7728*sin(x(3))^2 - 6.8707*cos(x(3))^2 + 2694.6)*(224.67058200000000546481260244036*sin(x(1))*sin(x(3)) + 6.7728*x(2)^2*cos(x(3))^2 - 6.7728*x(2)^2*sin(x(3))^2 - 6.8707*x(2)*x(6)*cos(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (877938.48224119612192546017466339*cos(x(3))^3*sin(x(3))*(u(3) + 6.8707*x(2)*x(6)*sin(x(3))))/(- 5759.6910494099996838927654607687*cos(x(3))^2 + 50.06182848*sin(x(3))^2 + 19917.40536)^2 + (519.13154110999998562760993081611*x(2)*x(6)*cos(x(3))^3)/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (151.11459999999999581632437184453*cos(x(3))*sin(x(3))*(u(3) + 6.8707*x(2)*x(6)*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) + (27.287*cos(x(3))*sin(x(3))*(6.7728*cos(x(3))*sin(x(3))*x(2)^2 - 6.8707*x(6)*sin(x(3))*x(2) + u(2) - 224.67058200000000546481260244036*cos(x(3))*sin(x(1))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (877938.48224119612192546017466339*cos(x(3))^2*sin(x(3))*(8629.2075779999995199887052876875*sin(x(1)) - 1.0*u(1) - 75.557299999999997908162185922265*x(4)^2*sin(x(3)) + 224.67058200000000546481260244036*cos(x(1))*sin(x(3)) + 6.8707*x(4)*x(6)*sin(x(3)) + 13.5456*x(2)*x(4)*cos(x(3))*sin(x(3))))/(- 5759.6910494099996838927654607687*cos(x(3))^2 + 50.06182848*sin(x(3))^2 + 19917.40536)^2 - (11619.505755779999367785530921537*cos(x(3))*sin(x(3))*(6.7728*sin(x(3))^2 - 6.8707*cos(x(3))^2 + 2694.6)*(6.7728*cos(x(3))*sin(x(3))*x(2)^2 - 6.8707*x(6)*sin(x(3))*x(2) + u(2) - 224.67058200000000546481260244036*cos(x(3))*sin(x(1))))/(- 5759.6910494099996838927654607687*cos(x(3))^2 + 50.06182848*sin(x(3))^2 + 19917.40536)^2, (75.557299999999997908162185922265*cos(x(3))*(6.8707*x(6)*sin(x(3)) - 151.11459999999999581632437184453*x(4)*sin(x(3)) + 13.5456*x(2)*cos(x(3))*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536), 0,                          (519.13154110999998562760993081611*x(2)*cos(x(3))^2*sin(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (6.8707*x(2)*sin(x(3))*(6.7728*sin(x(3))^2 - 6.8707*cos(x(3))^2 + 2694.6))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) + (519.13154110999998562760993081611*x(4)*cos(x(3))*sin(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536);
    0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     0,                                                                                                                                                                                                                               0, 0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                           1;
    (7.3916*cos(x(3))*(8629.2075779999995199887052876875*cos(x(1)) - 224.67058200000000546481260244036*sin(x(1))*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (16975.502565348599942932066107915*cos(x(1))*cos(x(3))^3)/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536), (100.12365696*x(4)*cos(x(3))^2*sin(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (75.557299999999997908162185922265*cos(x(3))^2*(6.8707*x(6)*sin(x(3)) - 13.5456*x(2)*cos(x(3))*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) + (6.8707*x(6)*sin(x(3))*(50.06182848*sin(x(3))^2 - 5708.9055832899996838927654607687*cos(x(3))^2 + 19917.40536))/(343.959804937536*sin(x(3))^2 - 39573.109293181284828122023651304*cos(x(3))^2 + 136846.517006952), (75.557299999999997908162185922265*cos(x(3))^2*(224.67058200000000546481260244036*sin(x(1))*sin(x(3)) + 6.7728*x(2)^2*cos(x(3))^2 - 6.7728*x(2)^2*sin(x(3))^2 - 6.8707*x(2)*x(6)*cos(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) + (7.3916*cos(x(3))*(224.67058200000000546481260244036*cos(x(1))*cos(x(3)) - 75.557299999999997908162185922265*x(4)^2*cos(x(3)) + 6.8707*x(4)*x(6)*cos(x(3)) + 13.5456*x(2)*x(4)*cos(x(3))^2 - 13.5456*x(2)*x(4)*sin(x(3))^2))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (7.3916*sin(x(3))*(8629.2075779999995199887052876875*sin(x(1)) - 1.0*u(1) - 75.557299999999997908162185922265*x(4)^2*sin(x(3)) + 224.67058200000000546481260244036*cos(x(1))*sin(x(3)) + 6.8707*x(4)*x(6)*sin(x(3)) + 13.5456*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (877938.48224119612192546017466339*cos(x(3))^3*sin(x(3))*(6.7728*cos(x(3))*sin(x(3))*x(2)^2 - 6.8707*x(6)*sin(x(3))*x(2) + u(2) - 224.67058200000000546481260244036*cos(x(3))*sin(x(1))))/(- 5759.6910494099996838927654607687*cos(x(3))^2 + 50.06182848*sin(x(3))^2 + 19917.40536)^2 + (11517.934823539999367785530921537*cos(x(3))*sin(x(3))*(u(3) + 6.8707*x(2)*x(6)*sin(x(3))))/(343.959804937536*sin(x(3))^2 - 39573.109293181284828122023651304*cos(x(3))^2 + 136846.517006952) - (151.11459999999999581632437184453*cos(x(3))*sin(x(3))*(6.7728*cos(x(3))*sin(x(3))*x(2)^2 - 6.8707*x(6)*sin(x(3))*x(2) + u(2) - 224.67058200000000546481260244036*cos(x(3))*sin(x(1))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (85886.738744423443326923530359636*cos(x(3))^2*sin(x(3))*(8629.2075779999995199887052876875*sin(x(1)) - 1.0*u(1) - 75.557299999999997908162185922265*x(4)^2*sin(x(3)) + 224.67058200000000546481260244036*cos(x(1))*sin(x(3)) + 6.8707*x(4)*x(6)*sin(x(3)) + 13.5456*x(2)*x(4)*cos(x(3))*sin(x(3))))/(- 5759.6910494099996838927654607687*cos(x(3))^2 + 50.06182848*sin(x(3))^2 + 19917.40536)^2 - (79834.138196237641656244047302607*cos(x(3))*sin(x(3))*(u(3) + 6.8707*x(2)*x(6)*sin(x(3)))*(50.06182848*sin(x(3))^2 - 5708.9055832899996838927654607687*cos(x(3))^2 + 19917.40536))/(- 39573.109293181284828122023651304*cos(x(3))^2 + 343.959804937536*sin(x(3))^2 + 136846.517006952)^2 + (6.8707*x(2)*x(6)*cos(x(3))*(50.06182848*sin(x(3))^2 - 5708.9055832899996838927654607687*cos(x(3))^2 + 19917.40536))/(343.959804937536*sin(x(3))^2 - 39573.109293181284828122023651304*cos(x(3))^2 + 136846.517006952),                            (7.3916*cos(x(3))*(6.8707*x(6)*sin(x(3)) - 151.11459999999999581632437184453*x(4)*sin(x(3)) + 13.5456*x(2)*cos(x(3))*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536), 0, (6.8707*x(2)*sin(x(3))*(50.06182848*sin(x(3))^2 - 5708.9055832899996838927654607687*cos(x(3))^2 + 19917.40536))/(343.959804937536*sin(x(3))^2 - 39573.109293181284828122023651304*cos(x(3))^2 + 136846.517006952) - (519.13154110999998562760993081611*x(2)*cos(x(3))^2*sin(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) + (50.78546612*x(4)*cos(x(3))*sin(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536);
    ];

B_eval =...
    [                                                                                                                                0,                                                                                                                                        0,                                                                                                                                                                                       0;
    7.3916/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536),         -(75.557299999999997908162185922265*cos(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536),                                                                                   -(7.3916*cos(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536);
    0,                                                                                                                                        0,                                                                                                                                                                                       0;
    -(75.557299999999997908162185922265*cos(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536), (1.0*(6.7728*sin(x(3))^2 - 6.8707*cos(x(3))^2 + 2694.6))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536),                                                       (75.557299999999997908162185922265*cos(x(3))^2)/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536);
    0,                                                                                                                                        0,                                                                                                                                                                                       0;
    -(7.3916*cos(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536),        (75.557299999999997908162185922265*cos(x(3))^2)/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536), (1.0*(50.06182848*sin(x(3))^2 - 5708.9055832899996838927654607687*cos(x(3))^2 + 19917.40536))/(343.959804937536*sin(x(3))^2 - 39573.109293181284828122023651304*cos(x(3))^2 + 136846.517006952);
    ];
end