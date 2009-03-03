function [X,F,F2] = steady(X,u)

% STEADY Null evolution function
%   [X,F] = STEADY(X) is the null evolution function for vector states. Its
%   outputs are the trivial values
%
%       X = X
%       F = eye(length(X))
%
%   [X,F,F2] = STEADY(X,X2) ignores X2 and returns F2 = F;
%
%   See also EPREDICT, OBSERVE

F = eye(length(X));

if nargout == 3
    F2 = F;
end