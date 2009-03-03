function [Li,MD,Inn] = blockLikelihood(r1,r2,Obs,ye,H1,H2)

% BLOCKLIKELIHOOD Likelihood for block systems
%
%   BLOCKLIKELIHOOD(R1,R2,OBS,YE,H1,H2,R) gives the likelihood
%   of the state Map.X given observation 
%
%     OBS.Y = h(x1,x2) + v
%
%   with v~N(0,OBS.R), and expected observation 
%
%     YE = h(Map.X(R1),Map.X(R2)).
%
%   H1 and H2 are the Jacobians of h wrt x1 and x2 evaluated
%   at Map.X(R1) and Map.X(R2).
%
%   R1 and R2 are the ranges where x1 and x2 are represented
%   in the map Map.
%
%   Global variable Map is a normal distribution containing
%     X: the state vector
%     P: the covariances matrix
%  
%   [Li,MD] = BLOCKLIKELIHOOD(...) also returns the Mahalanobis
%   distance.
%
% See also LIKELIHOOD

global Map

P = Map.P([r1 r2],[r1 r2]);
H = [H1 H2];    

[Li,MD,Inn] = likelihood(P,Obs.y,H,Obs.R,ye);
