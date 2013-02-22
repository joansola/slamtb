function [l, L_seg, L_n, L_k, L_c] = invPinHoleIdpLin(seg,n,k,c)

% INVPINHOLEIDPLIN IDP line retro projection.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


if nargin < 4
    c = zeros(1,0);
    if nargin < 3
        k = [0;0;1;1];
    end
end

u1 = seg(1:2,:);
u2 = seg(3:4,:);

if nargout == 1 % only point

    v1  = invPinHole(u1,1,k,c);
    v2  = invPinHole(u2,1,k,c);
    py1 = vec2py(v1);
    py2 = vec2py(v2);
    l   = [0;0;0;py1;n(1);py2;n(2)];

else % Jacobians

    if size(seg,2) > 1
        error('Jacobians not available for multiple pixels')
    else

        [v1, V1_u1, V1_1, V1_k, V1_c] = invPinHole(u1,1,k,c);
        [v2, V2_u2, V2_1, V2_k, V2_c] = invPinHole(u2,1,k,c);
        [py1,PY1_v1] = vec2py(v1);
        [py2,PY2_v2] = vec2py(v2);

        l     = [0;0;0;py1;n(1);py2;n(2)];
        L_py1 = [zeros(3,2);eye(2);zeros(4,2)];
        L_py2 = [zeros(6,2);eye(2);zeros(1,2)];
        L_n1  = [0;0;0;0;0;1;0;0;0];
        L_n2  = [0;0;0;0;0;0;0;0;1];
        
        L_v1 = L_py1*PY1_v1;
        L_v2 = L_py2*PY2_v2;
        
        L_u1  = L_v1*V1_u1;
        L_u2  = L_v2*V2_u2;

        L_seg = [L_u1 L_u2];
        L_n   = [L_n1 L_n2];
        
        L_k   = L_v1*V1_k + L_v2*V2_k;
        L_c   = L_v1*V1_c + L_v2*V2_c;

    end

end

return
%% jac
syms p1 p2 q1 q2 u0 v0 au av n1 n2 c2 c4 c6 real
s = [p1;p2;q1;q2];
k = [u0;v0;au;av];
c = [c2;c4;c6];
% c = [];
n = [n1;n2];

l = invPinHoleIdpLin(s,n,k,c)

%%
[l,L_s,L_n,L_k,L_c] = invPinHoleIdpLin(s,n,k,c);

simplify(L_s - jacobian(l,s))
simplify(L_n - jacobian(l,n))
simplify(L_k - jacobian(l,k))
simplify(L_c - jacobian(l,c))









