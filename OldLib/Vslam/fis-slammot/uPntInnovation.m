function Pnt = uPntInnovation(Pnt,prj,y,R)

% UPNTINNOVATION  Pnt innovation statistics
%   PNT = UPNTINNOVATION(PNT,PRJ,Y,R) computes innovation
%   statistics for the point PNT given the observation {y,R} and
%   the expectations included in PNT.Prj(PRJ) structure:
%     .u  : expectation
%     .U  : expectation covariance
%   The following PNT structure fields are updated:
%     .z  : innovation
%     .Z  : innovation covariance
%     .iZ : inverse of innovation covariance
%     .MD : Mahalanobis distance
%
%   See also URAYINNOVATION, UINNOVATION

[z,Z,iZ] = uInnovation(...
    y,...
    R,...
    Pnt.Prj(prj).u,...
    Pnt.Prj(prj).U);
MD = z'*iZ*z;

Pnt.Prj(prj).z  = z;
Pnt.Prj(prj).Z  = Z;
Pnt.Prj(prj).iZ = iZ;
Pnt.Prj(prj).MD = MD; % Mahalanobis distance

