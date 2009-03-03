function [y,Y] = propagateUncertainty(x,X,f)

% PROPAGATEUNCERTAINTY  Non-linear propagation of Gaussian uncertainty.
%   [y,Y] = PROPAGATEUNCERTAINTY(x,X,@f) propagates the Gaussian
%   uncertainty N(x,X) through function f(), resulting in the Gaussian
%   approximation N(y,Y).
%
%   The propagation is made by using the Jacobian of f(), thus the function
%   in file f.m must have the form [y,F] = f(x), with F the Jacobian of f()
%   wrt x.
%
%   See also Q2EG.

[y,Y_x] = f(x);
Y = Y_x*X*Y_x';

return

%% test

x = randn(3,1)
X = randn(3)/1e5
[y,Y] = propagateUncertainty(x,X,@e2q)
[x,X] = propagateUncertainty(y,Y,@q2e)
