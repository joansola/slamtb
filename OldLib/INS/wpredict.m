function [w,Wwi,Wra] = wpredict(wi)

% WPREDICT Prediction function for angular rate from angular rate
%   [W,Wwi] = WPREDICT(WI) assigns W = WI and gives the identity Jacobian
%   Wwi.

w = wi;
Wwi = eye(length(wi));
Wra = Wwi;
