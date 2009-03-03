function Idp = uIdpInnovation(Idp,prj,y,R)

% UIDPINNOVATION  Idp innovation statistics
%   IDP = UIDPINNOVATION(IDP,PRJ,Y,R) computes innovation statistics for
%   the inverse depth point IDP given the observation {y,R} and the
%   expectations included in IDP.Prj(PRJ) structure:
%     .u  : expectation
%     .U  : expectation covariance
%   The following IDP structure fields are updated:
%     .z  : innovation
%     .Z  : innovation covariance
%     .iZ : inverse of innovation covariance
%     .MD : Mahalanobis distance
%
%   This function just calls UPNTINNOVATION with the same arguments.
%
%   See also UPNTINNOVATION, UINNOVATION

Idp = uPntInnovation(Idp,prj,y,R);

