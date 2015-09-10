function [at, AT_y, AT_x] = atan2jac(y,x)

% ATAN2JAC the atan2 function with return of Jacobians
%   ATAN2JAC(Y,X) is the same as ATAN2(Y,X).
%
%   [A, A_y, A_x] = ATAN2JAC(Y,X) returns the Jacobians wrt the inputs Y
%   and X. Mind the order of the arguments, first Y, then X, is the same as
%   the order of the returned Jacobians.

%   Copyright 2015- Joan Sola @ IRI-CSIC-UPC

at = atan2(y,x);

if nargout > 1
    AT_y = 1/(x*(y^2/x^2 + 1));
    AT_x = -y/(x^2*(y^2/x^2 + 1));
end

