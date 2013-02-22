function [L1,L1_l,L1_x1] = reanchorPlucker(L0,x1)

% REANCHORPLUCKER  Plucker to anchored Plucker line conversion
%   REANCHORPLUCKER(L,X) reanchors the anchored Plucker line L to the point X.
%
%   [L1,L1_l,L1_x] = REANCHORPLUCKER(L,X) returns the Jacobians.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


x0 = L0(1:3);
n0 = L0(4:6);
v0 = L0(7:9);

L1 = [x1; n0 + cross((x0-x1),v0); v0];

if nargout > 1

    Z33 = zeros(3);
    I33 = eye(3);

    L1_l = [...
        Z33      Z33    Z33
        -hat(v0) I33 hat(x0-x1)
        Z33      Z33    I33];
    
    L1_x1 = [...
        I33
        hat(v0)
        Z33];
    
end

return

%%
syms t1 t2 t3 x1 x2 x3 a b c d n1 n2 n3 v1 v2 v3 y1 y2 y3 real

L0 = [x1;x2;x3;n1;n2;n3;v1;v2;v3];
y = [y1;y2;y3];

[L1,L1_l,L1_y] = reanchorPlucker(L0,y);

simplify(L1_l - jacobian(L1,L0))
simplify(L1_y - jacobian(L1,y))










