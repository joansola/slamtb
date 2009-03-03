function [L,Lc,Lk,Lrt,Lbeta] = retroProjectPluckerInRhoTheta(C,k,rt,beta)

% RETROPROJECTPLUCKERINRHOTHETA  Retro project Plucker line
%   L = RETROPROJECTPLUCKERINRHOTHETA(C,K,RT,beta) retro-projects the line
%   RT in rho-theta code perceived in a camera with intrinsic parameters K
%   at frame C, using the unobservable director vector beta, defined in the
%   plane containing the measured line l and the camera origin.
%
%   [L,Lc,Lk,Lrt,Lbeta] = ... returns the Jacobians wrt C, K, RT and beta.
%
%   See also RETROPROJECTPLUCKER

% (c) 2008 Joan Sola @ LAAS-CNRS

if nargout == 1
    
    L = retroProjectPlucker(C,k,rt2hm(rt),beta);
    
else
    
    [hm,HMrt] = rt2hm(rt);
    [L,Lc,Lk,Lhm,Lbeta] = retroProjectPlucker(C,k,hm,beta);
    Lrt = Lhm*HMrt;
    
end