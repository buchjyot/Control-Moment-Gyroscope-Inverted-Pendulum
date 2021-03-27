function getPlots(params,structEKF,structUKF)

% Ploting Kalman Gain values for EKF
figure(1);
subplot(2,1,1);
plot(params.t,structEKF.G);
legend('G_1','G_2','G_3','G_4','G_5','G_6');
grid;
title('Kalman Gain for EKF');

% Ploting Kalman Gain values for UKF
figure(1);
subplot(2,1,2);
plot(params.t,structUKF.G);
legend('G_1','G_2','G_3','G_4','G_5','G_6');
grid;
title('Kalman Gain for UKF');
print -depsc epsFig1;

% Ploting Output plot
figure(2);
plot(params.t,structEKF.Ym,'r*');
hold on;
plot(params.t,structEKF.Yest,'b');
plot(params.t,structUKF.Yest,'m');
plot(params.t,structEKF.Yact,'black');
legend('Y-Measurement','Y-EKF','Y-UKF','Y-Actual');
grid;
xlabel('Simulation time(Sec)');
ylabel('Theta1(rad)');
title('Estimated Output Comparision');
print -depsc epsFig2;

% Plotting Calcuated Controller output
figure(4);
plot(params.t,structEKF.u(2:end,:));
legend('Tau 1','Tau 2','Tau 3');
grid;
xlabel('Simulation time(Sec)');
ylabel('Input u');
print -depsc epsFig4;
end