function [b,Bb,Br] = bpredict(b)

% BPREDICT Bias prediction
%   BPREDICT(V) performs the time update B = B
%
%   [B,Bb] = ... returns the Jacobian matrix wrt bias B.
%
%   [B,Bb,Br] = ... also returns the Jacobian wrt the additive white
%   Gaussian noise R, which is ommited from the inputs because it is of
%   mean zero.
%
%   See also SPREDICT, RPREDICT, VPREDICT, QPREDICT, AMEASURE, WMEASURE

[b,Bb] = steady(b);
Br = eye(length(b));