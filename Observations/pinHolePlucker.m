function [l,v,Lk,Ll] = pinHolePlucker(k,L)

% PINHOLEPLUCKER  Projects plucker line.
%   PINHOLEPLUCKER(K,L) projects the Plucker line L into a pin hole camera
%   K=[u0;v0;au;av] at the origin.
%
%   [l,Lk,Ll] = ... returns Jacobians wrt K and L.
%
%   See also PINHOLE.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

[u0,v0,au,av] = split(k);
[L1,L2,L3]    = split(L);

l = [...
    av*L1
    au*L2
    -u0*av*L1-au*v0*L2+au*av*L3];

v = L(4:6);

if nargout > 2
    
    Lk = [...
        [            0,            0,            0,           L1]
        [            0,            0,           L2,            0]
        [       -av*L1,       -au*L2, -v0*L2+av*L3, -u0*L1+au*L3]];
    
    Ll = [...
        [     av,      0,      0,      0,      0,      0]
        [      0,     au,      0,      0,      0,      0]
        [ -u0*av, -au*v0,  au*av,      0,      0,      0]];

end

return
%%
syms L1 L2 L3 L4 L5 L6 real
syms u0 v0 au av real

k = [u0 v0 au av];
L = [L1 L2 L3 L4 L5 L6]';

l = pinHolePlucker(k,L)

Lk = jacobian(l,k)
Ll = jacobian(l,L)









