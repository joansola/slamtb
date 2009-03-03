function Pnt = uPntInnovation(Pnt,y,R)

% UPNTINNOVATION  Pnt innovation statistics
%   PNT = UPNTINNOVATION(PNT) computes innovation statistics for
%   the point PNT given the observation {y,R} and the expectations
%   included in PNT structure:
%     .u  : expectation
%     .U  : expectation covariance
%   The following PNT structure fields are updated:
%     .z  : innovation
%     .Z  : innovation covariance
%     .iZ : inverse of innovation covariance
%     .MD : Mahalanobis distance
%     .li : likelihood (without the 1/sqrt(2*pi) factor)
%
%   See also URAYINNOVATION, UINNOVATION

[z,Z,iZ] = uInnovation(...
    y,...
    R,...
    Pnt.u,...
    Pnt.U);
MD = z'*iZ*z;

Pnt.z  = z;
Pnt.Z  = Z;
Pnt.iZ = iZ;
Pnt.MD = MD; % Mahalanobis distance

