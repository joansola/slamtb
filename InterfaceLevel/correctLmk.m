function [Rob,Sen,Lmk,Obs] = correctLmk(Rob,Sen,Lmk,Obs,Opt)

% CORRECTLMK  Correct landmark.
%   [Rob,Sen,Lmk,Obs] = CORRECTLMK(Rob,Sen,Lmk,Obs,Opt) performs all
%   landmark correction steps in EKF SLAM: stochastic EKF correction,
%   landmark reparametrization, and non-stochastic landmark correction (for
%   landmark parameters not maintained in the stochastic map).

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

% EKF correction
[Rob,Sen,Lmk,Obs] = ekfCorrectLmk(Rob,Sen,Lmk,Obs);

% Negative inverse distance correction
% Lmk = correctNegIdp(Lmk); % I DON'T LIKE THIS SOLUTION. Rather use a
% better isVisible() function.

% Transform to cheaper parametrization if possible
if Opt.correct.reparametrize
    [Lmk,Obs] = reparametrizeLmk(Rob,Sen,Lmk,Obs,Opt);
end

% Update off-filter parameters
Lmk = updateLmkParams(Rob,Sen,Lmk,Obs,Opt);

% update flags and info
Obs.updated = true;









