function [y,H] = observe(x)

% OBSERVE Identity observation function
%   [Y,H] = OBSERVE(X) is the identity observation function Y = X. It
%   also returns the Jacobian H = I.
%
%   See also STEADY

y = x;
H = eye(length(x));