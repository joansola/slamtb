function [L,L_u,L_k] = pix2PluckerRay(k,u)

% PIX2PLUCKERRAY  Plucker ray from optical center through pixel.
%   PIX2PLUCKERRAY(K,U) is a Plucker line passing over pixel U and the
%   optical center, in a pin-Hole camera of intrinsic vector K.
%
%   [R, R_k, R_u] = PIX2PLUCKERRAY(...) returns the Jacobians wrt K and U.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargout == 1

    n = [0;0;0];
    v = invPinHole(u,1,k);

    L = [n;v];

else

    n = [0;0;0];
    [v,V_u,~,V_k] = invPinHole(u,1,k);

    L = [n;v];
    L_u = [zeros(3,2);V_u];
    L_k = [zeros(3,4);V_k];

end

return

%%
syms u1 u2 u0 v0 au av real
k = [u0;v0;au;av];
u = [u1;u2];

[L,L_u,L_k] = pix2PluckerRay(k,u);

simplify(L_u - jacobian(L,u))
simplify(L_k - jacobian(L,k))









