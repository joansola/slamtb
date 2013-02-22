function [l, L_seg, L_n, L_k, L_c] = invPinHoleHmgLin(seg,n,k,c)

% INVPINHOLEHMGLIN IDP line retro projection.

%   Copyright 2009 Teresa Vidal, Joan Sola.


if nargin < 4
    c = zeros(1,0);
    if nargin < 3
        k = [0;0;1;1];
    end
end

u1 = seg(1:2,:);
u2 = seg(3:4,:);

if nargout == 1 % only point

    v1  = invPinHoleHmg(u1,n(1),k,c);
    v2  = invPinHoleHmg(u2,n(2),k,c);
    l   = [v1;v2];

else % Jacobians

    if size(seg,2) > 1
        error('Jacobians not available for multiple pixels')
    else

        [v1, V1_u1, V1_n, V1_k, V1_c] = invPinHoleHmg(u1,n(1),k,c);
        [v2, V2_u2, V2_n, V2_k, V2_c] = invPinHoleHmg(u2,n(2),k,c);

        l     = [v1;v2];
        %FIXME Check if this is correct   
        L_u1  = V1_u1;
        L_u2  = V2_u2;

        L_seg = blkdiag(L_u1, L_u2);
        L_n   = blkdiag(V1_n, V2_n);
        
        L_k   = [V1_k; V2_k];
        L_c   = [V1_c; V2_c];

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

l = invPinHoleHmgLin(s,n,k,c)

%%
[l,L_s,L_n,L_k,L_c] = invPinHoleHmgLin(s,n,k,c);

simplify(L_s - jacobian(l,s))
simplify(L_n - jacobian(l,n))
simplify(L_k - jacobian(l,k))
simplify(L_c - jacobian(l,c))









