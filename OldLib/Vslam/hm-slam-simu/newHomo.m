function H = newHomo(H,id,smin,rho,lostTh)

% NEWRAY  Create new ray
%   R = NEWRAY(R,ID,SMIN,SMAX,A,B,G,T) fills appropiate 
%   fields of ray R to accomodate a ray with parameters:
%     ID:   ray identifier
%     SMIN: minimum depth
%     SMAX: maximum depth
%     A:    aspect ratio 'alpha'
%     B:    geometric base 'beta'
%     G:    vanishing factor 'gamma'
%     T:    pruning threshold 'tau'
%
%   See also EMPTYRAY

%global Image

% usage
H.used = true;
H.id   = id;

% visibility
H.front = true;
H.vis   = true;

