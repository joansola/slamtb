function r = addToMap(x,P,r)

% ADDTOMAP  Add Gaussian to Map.
%   ADDTOMAP(x,P) adds the Gaussian N(x,P) to the global EKF-map Map and
%   returns the range where it has been added. ADDTOMAP adds mean x in
%   Map.x and covariances P in the block-diagonal of Map.P.
%
%   Map is a global structure, containing:
%       .used   a vector of logicals indicating used positions
%       .x      the state vector
%       .P      the covariances matrix
%       .size   the Map's maximum size, numel(Map.x)
%
%   ADDTOMAP(x,P,R) permits indicating the range R as input.
%
%   See also NEWRANGE.

%   (c) 2009 Joan Sola @ LAAS-CNRS.

global Map

if nargin == 2
    r = newRange(numel(x));
end
Map.used(r) = true;
Map.x(r)    = x;
Map.P(r,r)  = P;

