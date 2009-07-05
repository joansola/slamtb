function [Rob,Sen,Lmk,Obs] = correctLmk(Rob,Sen,Lmk,Obs,Opt)

% CORRECTLMK  Correct landmark.
%   [Rob,Sen,Lmk,Obs] = CORRECTLMK(Rob,Sen,Lmk,Obs,Opt) performs all
%   landmark correction steps in EKF SLAM: stochastic EKF correction,
%   landmark reparametrization, and non-stochastic landmark correction (for
%   landmark parameters not maintained in the stochastic map).

% EKF correction
[Rob,Sen,Lmk,Obs] = ekfCorrectLmk(Rob,Sen,Lmk,Obs);

% Transform to cheaper parametrization if possible
[Lmk,Obs] = reparametrizeLmk(Rob,Sen,Lmk,Obs,Opt);

% Update off-filter parameters
Lmk = updateLmkParams(Rob,Sen,Lmk,Obs,Opt);

% update flags and info
Obs.updated = true;
