function rmse = robotRmse(Rob,SimRob)

% ROBOTRMSE Robot's estimation root mean squared error.
%   ROBOTRMSE(ROB,SIMROB) computes the RMSE of the estimated robot ROB wrt
%   ground truth SIMROB. The result is the RMSE corresponding to the 6-DOF
%   robot frame expressed in Euler angles.
%
%   See also RMSE, RMSEANALYSIS, RMSEPLOTS, SLAMTBSLAVE.

%   Copyright 2009 Joan Sola @ LAAS-CNRS.

global Map;

% frame range
s = 1:7;

% ground truth
x = SimRob.frame.x(s);

% estimate - quat
r = Rob(1).frame.r(s);
m = Map.x(r);
P = Map.P(r,r);

% go to Euler
x = qpose2epose(x);
[m,P] = propagateUncertainty(m,P,@qpose2epose);

% estimation error
e      = m - x;
e(4:6) = normAngle(e(4:6));
std    = sqrt(diag(P));
rmse   = [e' std'];








