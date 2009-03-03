function Rob = odoPredict(Rob,Odo)

% ODOPREDICT  Robot motion EKF prediction from odometry data
%   Rob = ODOPREDICT(Rob,Odo) performs ekf slam robot motion for a robot
%   Rob in a map Map evolving with odometry readings Odo.
%   Rob is a structure containing:
%     .r: robot pose range in Map
%   Map is a structure containing:
%     .X: state vector
%     .P: covariances matrix
%   Odo is a structure containing:
%     .u: mean of odometry vector
%     .U: covariances matrix

global Map

% new robot pose
[Rob,Fr,Fu] = odo3(Rob,Odo.u);
Rob = updateFrame(Rob);

% update map state
Map.X(Rob.r) = Rob.X;

% update map covariance
blockPredict(Rob.r,Fr,Fu,Odo.U);

