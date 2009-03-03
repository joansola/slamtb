function [uhm,UHM_hm] = hm2uhm(hm)

% HM2UHM  Homogeneous to unit homogeneous transform.
%   HM2UHM(HM) returns a unit-normalized vector equivalent to HM.
%
%   [hm,UHM_hm] = HM2UHM(HM) returns the Jacobian wrt HM. This Jacobian is
%   not equal to dUHM/dHM but just the scale change matrix corresponding to
%   the normalization: UHM_hm = eye(numel(HM))/norm(HM). This is to avoid
%   degenerated covariances. Use NORMVEC if you want to have control over
%   this behavior.
%
%   See also NORMVEC.

nhm = sqrt(dot(hm,hm));
uhm = hm/nhm;

if nargout > 1
    UHM_hm = eye(numel(hm))/nhm;
end
