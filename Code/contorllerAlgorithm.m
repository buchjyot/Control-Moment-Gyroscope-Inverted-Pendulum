function contorllerAlgorithm(params)
%%

params.dt = 0.01;
params.t = 0:params.dt:10;

%local Parametes
x0 = params.x0;
t = params.t;
dt = params.dt;
options = params.options;
u = params.u;
C = params.C;
Q = diag([1000 10 1 0.01 0.001 0.001]);
R = diag([1000 10 1]);

X(1,:) = x0;

% for i = 1:length(t)
%     [A,B] = getDerivative(X(i,:),u(i,:)); % linearize the plant
%     K = lqr(A,B,Q,R);
%     [X(i+1,:), Y(i)] = actualTrajac(u,C,X(i,:),dt,options);%#ok
%     u(i+1,:) = 1 -K*X(i+1,:)';
% end
% 
% plot(t,X(2:end,:));
 for i = 1:length(t)
     [X(i+1,:), Y(i)] = actualTrajac(u,C,X(i,:),dt,options);%#ok
 end
 plot(t,X(2:end,:))
 legend('X_1','X_2','X_3','X_4','X_5','X_6');
end

function [Xactp, Yact] = actualTrajac(u,C,X0act,dt,options)
[~,stateActX] = ode23tb(@(t,X)getStates(X,u),[0 dt],X0act,options);
Xactp = stateActX(end,:); % Predicted actual state;
Yact = C*X0act'; % Current acutal value
end

function dxdt = getStates(x,u,varargin)
   dxdt = [x(2);
        -(1.0*(63783.650733544796451948514004471*sin(x(1)) - 7.3916*u(1) - 558.48933867999998453797161346301*x(4)^2*sin(x(3)) + 1660.6750739112000403937088321982*cos(x(1))*sin(x(3)) - 16975.502565348599942932066107915*cos(x(3))^2*sin(x(1)) + 75.557299999999997908162185922265*u(2)*cos(x(3)) + 7.3916*u(3)*cos(x(3)) + 50.78546612*x(4)*x(6)*sin(x(3)) + 511.73448143999998583240085281432*x(2)^2*cos(x(3))^2*sin(x(3)) + 150.90912308*x(2)*x(4)*cos(x(3))*sin(x(3)) - 519.13154110999998562760993081611*x(2)*x(6)*cos(x(3))*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536);
        x(4);
        (2694.6*u(2) - 6.8707*u(2)*cos(x(3))^2 + 75.557299999999997908162185922265*u(3)*cos(x(3))^2 + 6.7728*u(2)*sin(x(3))^2 + 46602.275476019330955255846311048*cos(x(3))*sin(x(1)) + 1543.644167747400037547087947587*cos(x(3))^3*sin(x(1)) - 75.557299999999997908162185922265*u(1)*cos(x(3)) + 16975.502565348599942932066107915*cos(x(1))*cos(x(3))*sin(x(3)) - 18513.78822*x(2)*x(6)*sin(x(3)) + 45.87081984*x(2)^2*cos(x(3))*sin(x(3))^3 - 46.53387696*x(2)^2*cos(x(3))^3*sin(x(3)) - 1521.6489177696000370120827938081*cos(x(3))*sin(x(1))*sin(x(3))^2 - 46.53387696*x(2)*x(6)*sin(x(3))^3 + 18249.98688*x(2)^2*cos(x(3))*sin(x(3)) - 5708.9055832899996838927654607687*x(4)^2*cos(x(3))*sin(x(3)) + 519.13154110999998562760993081611*x(4)*x(6)*cos(x(3))*sin(x(3)) + 1542.6005039899999572924116364447*x(2)*x(4)*cos(x(3))^2*sin(x(3)) + 47.20651849*x(2)*x(6)*cos(x(3))^2*sin(x(3)))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536);
        x(6);
        (0.14554557759762469617360676495845*(19917.40536*u(3) + 519.13154110999998562760993081611*u(2)*cos(x(3))^2 - 5708.9055832899996838927654607687*u(3)*cos(x(3))^2 + 50.06182848*u(3)*sin(x(3))^2 + 438238.32909496623298240265517052*cos(x(3))*sin(x(1)) - 116633.58547574062562790334660765*cos(x(3))^3*sin(x(1)) - 50.78546612*u(1)*cos(x(3)) + 11410.000230321682117533055273384*cos(x(1))*cos(x(3))*sin(x(3)) + 136846.517006952*x(2)*x(4)*sin(x(3)) + 3515.9741016298079026586765394313*x(2)^2*cos(x(3))^3*sin(x(3)) + 343.959804937536*x(2)*x(4)*sin(x(3))^3 - 3837.2126992686758937650415646203*x(4)^2*cos(x(3))*sin(x(3)) + 348.931702070684*x(4)*x(6)*cos(x(3))*sin(x(3)) - 38536.257981235528828122023651304*x(2)*x(4)*cos(x(3))^2*sin(x(3)) - 3566.7970795044769012516195516582*x(2)*x(6)*cos(x(3))^2*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536);
        ];
end

%% Jacobians evaluated at current state 
function [A_eval,B_eval] = getDerivative(x,u)
A_eval =...
    [                                                                                                                                                                                                                                                                                                                                                                                                                      0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    1,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     0,                                                                                                                                                                                                                               0, 0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                      0;
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