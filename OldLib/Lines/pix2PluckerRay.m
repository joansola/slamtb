function [L,L_u,L_k] = pix2PluckerRay(k,u)

if nargout == 1

    n = [0;0;0];
    v = invPinHole(u,1,k);

    L = [n;v];

else

    n = [0;0;0];
    [v,V_u,V_s,V_k] = invPinHole(u,1,k);

    L = [n;v];
    L_u = [zeros(3,2);V_u];
    L_k = [zeros(3,4);V_k];

end

return

%%
syms u1 u2 u0 v0 au av real
k = [u0;v0;au;av];
u = [u1;u2];

[L,L_u,L_k] = pix2PluckerRay(k,u)

simplify(L_u - jacobian(L,u))
simplify(L_k - jacobian(L,k))
