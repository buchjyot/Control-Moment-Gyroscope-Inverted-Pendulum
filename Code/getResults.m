function [extendedKFRMSE,unscentedKFRMSE] = getResults(structEKF,structUKF)

extendedKFRMSE = sqrt(mean((structEKF.Yest - structEKF.Yact).^2));
unscentedKFRMSE = sqrt(mean((structUKF.Yest - structUKF.Yact).^2));
end