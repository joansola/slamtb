function Ng = numTerms(a,b,smin,smax)

% NUMTERMS  Number of terms of a geometric series of Gaussians
%   NUMTERMS(ALPHA,BETA,SMIN,SMAX) calculates the number of
%   Gaussians of the geometric series parametrized by ALPHA and
%   BETA to fill the space between SMIN and SMAX.
%
%   This number is
%
%   Ng = 1+ceil(log(((1-ALPHA)/(1+ALPHA))*((SMAX)/(SMIN)))/log(BETA))

Ng = 1+ceil(log(((1-a)/(1+a))*((smax)/(smin)))/log(b));

Ng = max(Ng,1); % at least one term!
