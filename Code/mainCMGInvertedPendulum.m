%% ----------------------------------------------------
% Main Routine for CMG Computation of EKF and UKF
% ----------------------------------------------------
clearVals(); % clearing workspace 
[f,x,h,w,v,f_jac,L,C,M] = symbolicDynamics(); % Symbolic dynamic math
[nState,t,dt,n,x0,Q,R,W,V,P0] = stateInit(); % States and simulation paramters initialization

% prefix 'e' stands for extendedKF and 'u' stands for UnscentedKF
% Extended Kalman - Bucy Filter
% [eG,eP,eXn,eYn,eXest,eYest,eXa,eYa,eu] = extendedKalmanFilter(Q,R,W,V,x0,P0,t,dt);
% extendedKFRMSE = sqrt(mean((eYest - eYa).^2));

% Unscented Kalman - Bucy Filter
[uG,uP,uXest,uYest,uXa,uYa,uu] = unscentedKalmanFilter(Q,R,x0,P0,t,dt);
unscentedKFRMSE = sqrt(mean((uYest - uYa).^2));

% Ploting Kalman Gain values for EKF
figure(1);subplot(2,1,1);plot(t,eG);
legend('G_1','G_2','G_3','G_4','G_5','G_6');grid;title('Kalman Gain for EKF');

% Ploting Kalman Gain values for UKF
figure(1);subplot(2,1,2);plot(t,uG);
legend('G_1','G_2','G_3','G_4','G_5','G_6');grid;title('Kalman Gain for UKF');print -depsc epsFig1;

% Ploting Output plot
figure(2);plot(t,eYn,'r*');hold on; plot(t,eYest,'b');plot(t,uYest,'m');plot(t,eYa,'black');
legend('Y-Measurement','Y-EKF','Y-UKF','Y-Actual');grid;
xlabel('Simulation time(Sec)'); ylabel('Theta1(rad)');title('Estimated Output Comparision');print -depsc epsFig2;

% Plotting State Response
% figure(3);plot(t,eXa(2:end,1));
% xlabel('Simulation time(Sec)');ylabel('Magnitude');
% title('Actual State Response(Without any Noise or Uncertainity)');hold on;plot(t,uXa(2:end,1));
% legend('eX_1','uX_1');grid;print -depsc epsFig3;

% Plotting Calcuated Controller output
figure(4);plot(t,eu(2:end,:));
legend('Tau 1','Tau 2','Tau 3');grid;
xlabel('Simulation time(Sec)');ylabel('Input u');print -depsc epsFig4;

% Print RMSE values in Command window
evalin('base','extendedKFRMSE');
evalin('base','unscentedKFRMSE');