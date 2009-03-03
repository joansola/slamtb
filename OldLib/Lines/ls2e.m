function [e,E_l,E_s] = ls2e(L,s)

% LS2E  Plucker line and abscissa to endpoint conversion
%   LS2E(L,S) is the endpoint of the Plucker line L at abscissa S.

v = L(4:6);

if nargout == 1

    e = lineOrigin(L) + s*normvec(v);

else % Jac
        
    [p0,P0_l] = lineOrigin(L);
    [vn,VN_v] = normvec(v,1);
    e = p0 + s*vn;
    E_s = vn;
    E_l = P0_l + [zeros(3) s*VN_v];

end

return

%% jac
syms n1 n2 n3 v1 v2 v3 s real
L = [n1;n2;n3;v1;v2;v3];

%% build
e = ls2e(L,s);

E_l = jacobian(e,L)
E_s = jacobian(e,s)

%% test
[e,E_l,E_s] = ls2e(L,s);

simplify(E_l - jacobian(e,L))
E_s - jacobian(e,s)

