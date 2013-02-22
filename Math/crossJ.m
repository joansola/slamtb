function [c,Ca,Cb] = crossJ(a,b)

% CROSSJ  Cross product with Jacobians output
%   CROSSJ(A,B) is equivalent to CROSS(A,B) when A and B are 3-vectors.
%
%   [c,Ca,Cb] = CROSSJ(A,B) returns the Jacobians wrt A and B.
%
%   See also CROSS, HAT.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

c = cross(a,b);

if nargout > 1
    
    Ca = -hat(b);

    Cb = hat(a);

end

return

%%

syms x y z u v w real
a = [x;y;z];
b = [u,v,w];

[c,Ca,Cb] = crossJ(a,b);

Ca - jacobian(c,a)

Cb - jacobian(c,b)










