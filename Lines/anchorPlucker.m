function [aL,AL_l,AL_x] = anchorPlucker(L,x)

% ANCHORPLUCKER  Plucker to anchored Plucker line conversion
%   ANCHORPLUCKER(L,X) anchors the Plucker line L to the point X.
%
%   [aL,AL_l,AL_x] = ANCHORPLUCKER(L,X) returns the Jacobians of the
%   conversion wrt L and X.

%   (c) 2009 Joan Sola @ LAAS-CNRS.

n = L(1:3);
v = L(4:6);

aL = [x;n-cross(x,v);v];

if nargout > 1
    
    Z33 = zeros(3);
    I33 = eye(3);
    
    AL_l = [...
        Z33 Z33
        I33 -hat(x)
        Z33 I33];
    
    AL_x = [...
        I33
        hat(v)
        Z33];
    
end

return

%% test jac

syms t1 t2 t3 x1 x2 x3 a b c d n1 n2 n3 v1 v2 v3 real

L = [n1;n2;n3;v1;v2;v3];
x = [x1;x2;x3];

[aL,AL_l,AL_x] = anchorPlucker(L,x);

simplify(AL_l - jacobian(aL,L))
simplify(AL_x - jacobian(aL,x))









