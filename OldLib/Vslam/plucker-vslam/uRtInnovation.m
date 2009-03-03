function Obs = uRtInnovation(Obs)

% URTINNOVATION  Rho-Theta line innovation statistics.
%   OBS = URTINNOVATION(OBS) computes innovation statistics for the line
%   observed in OBS. OBS is a structure containing a bunch of information
%   on the line observation. The following is needed to be up-to-date at
%   call time:
%       .y  : measurement in UHM units
%       .R  : measurement covariance in UHM
%       .u  : expectation in UHM
%       .U  : expectation covariance in UHM
%   The following fields in structure OBS are updated:
%       .z  : innovation
%       .Z  : innovation covariance
%       .iZ : inverse of innovation covariance
%       .MD : Mahalanobis distance
%
%   See also UINNOVATION.

inn = Obs.y - Obs.u;
innt = round(inn(2)/pi);

Obs.y(2) =  Obs.y(2) - innt*pi; % bring to small angle
if isodd(innt)           
    Obs.y(1) = -Obs.y(1);       % change rho sign
    disp('sign changed')
end


[z,Z,iZ] = uInnovation(Obs.y,Obs.R,Obs.u,Obs.U);
MD = z'*iZ*z;

Obs.z = z;
Obs.Z = Z;
Obs.iZ = iZ;
Obs.MD = MD;

