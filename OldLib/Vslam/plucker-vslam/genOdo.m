function Odo = genOdo(dx,de,dxNDR,deNDR,noiseFactor)

% GENODO  Generate odometry Gaussian vector
%   GENODO(DX,DE,DXDNR,DEDNR,NOISEFACTOR) generates a structure for the
%   Gaussian odometry vector, with fields
%       .u  the odometry vector
%       .U  the odometry's covariances matrix.
%   It used DX, DE as the inear and angular odometry increments, DXDNR,
%   DEDNR as the linear and angular distance to variance ratios, and
%   NOISEFACTOR as a factor between 0 and 1 to add a Gaussian random noise
%   to the mean .u.

% get odo reading
un    = norm(dx); % norm of step
Udx   = un * dxNDR * [1 1 1]'; % translation noise variance
Ude   = un * deNDR * [1 1 1]'; % rotation noise variance
Ud    = [Udx;Ude];

Odo.u = [dx;de] + noiseFactor*randn(6,1).*sqrt(Ud);
Odo.U = diag(Ud); % noise covariances matrix
