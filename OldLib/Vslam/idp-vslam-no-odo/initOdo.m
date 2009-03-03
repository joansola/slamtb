% INITODO  Init odometry data
%
%     Odo is the odometry containing
%       u: odometry data
%       U: odometry covariances matrix

global ODIM

% ODOMETRY
% ground truth
u    = zeros(ODIM,1);
u(1) = 0.2;       % m forward
% u(2) = 0.0;       % m left
% u(3) = 0.0;       % m up
% u(4) = 0.1;       %  rad clock roll
% u(5) = 0.2;       %  rad down  pitch
u(6) = u(1)/3;      %  rad left  yaw
% simulated realistic data
ud   = u(1) * 0.04 * [1 1 1 .1 .1 .1]'; % odometry noise std. deviation
U    = diag(ud)^2/10; % noise covariances matrix
Odo.U = U;

% ODO noise is proportional to translation:
%   position:    40 mm/m
%   orientation: 40 mrad/m (3º/m)

