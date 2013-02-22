function NEES = robotNees(Rob,SimRob)

% ROBOTNEES Robot's normalized estimation error squared.
%   ROBOTNEES(ROB,SIMROB) computes the NEES of the estimated robot ROB wrt
%   ground truth SIMROB. The result is the NEES corresponding to the 6-DOF
%   robot frame expressed in Euler angles.
%
%   See also NEES, NEESANALYSIS, NEESPLOTS, SLAMTBSLAVE.

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
e = x-m;
e(4:6) = normAngle(e(4:6));

% nees
NEES = nees(e,0,P);









