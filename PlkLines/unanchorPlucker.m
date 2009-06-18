function [L,L_al] = unanchorPlucker(aL)

% UNANCHORPLUCKER  Remove Plucker anchor.
%   UNANCHORPLUCKER(L) removes the anchor of the Plucker line L.
%
%   [L,L_Al] = UNANCHORPLUCKER(L,X) returns the Jacobians.

ax = aL(1:3);
an = aL(4:6);
av = aL(7:9);

L = [an + cross(ax,av);av];

if nargout > 1
    
    Z33 = zeros(3);
    I33 = eye(3);

    L_al = [...
        -hat(av) I33  hat(ax)
        Z33      Z33   I33];
    
end

return

%%

syms t1 t2 t3 x1 x2 x3 a b c d n1 n2 n3 v1 v2 v3 real

aL = [x1;x2;x3;n1;n2;n3;v1;v2;v3];

[L,L_al] = unanchorPlucker(aL);

simplify(L_al - jacobian(L,aL))
