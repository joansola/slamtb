function [z,Z,iZ] = uInnovation(y,R,u,U)

% UINNOVATION  Innovation in measure space
%   [z,Z,iZ] = UINNOVATION(y,R,u,U) computes the innovation of
%   the Gaussian observation {y,R} with respect to the
%   Gaussian expectation {u,U}.
%
%   See also INNOVATION

z  = y - u;
Z  = R + U;
iZ = inv(Z);
