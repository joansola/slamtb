function r = addToMap(x, P_LL, P_LX, r)

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
%   ADDTOMAP(x,P_LL,P_LX) accepts the cross variance matrix between x and the
%   currently used states in Map.x. It returns the range where the x has been
%   added.
%
%   P = | P       P_LX' |
%       |               |
%       | P_LX    P_LL  |
%   
%   ADDTOMAP(x,P_LL,P_LX,R) or ADDTOMAP(x,P_LL,[],R) permits indicating the
%   range R as input.
%
%   See also NEWRANGE, USEDRANGE.
%
%   (c) 2009 Joan Sola @ LAAS-CNRS.

global Map

% parse inputs
if nargin == 2
    P_LX = [] ;
end
if nargin <= 3
    r = newRange(numel(x));
end

% add to map
Map.x(r)    = x;
Map.P(r,r)  = P_LL;
if(size(P_LX)~=0)
    mr = usedRange();
    Map.P(r,mr) =  P_LX ;
    Map.P(mr,r) =  P_LX' ;
end ;

Map.used(r) = true;

