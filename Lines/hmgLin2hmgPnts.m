function [p1,p2,P1_l,P2_l] = hmgLin2hmgPnts(l)

% HMGLIN2HMGPNTS  HMG line to two IDP points conversion.
%   [P1,P2] = HMGLIN2HMGPNTS(L) extracts the two endpoints of the HMG line
%   L in the form of two HMG points.
%
%   [p1,p2,P1_l,P2_l] = HMGLIN2HMGPNTS(...) returns the Jacobians wrt L.

%   Copyright 2009 Teresa Vidal.

p1 = l(1:4,:);
p2 = l(5:8,:);

if nargout > 2

    P1_l = [eye(4)    zeros(4)];
    P2_l = [zeros(4)  eye(4)];

end

return

%% jac

syms p1 a1 b1 c1 n1 p2 a2 b2 c2 n2 real
l = [a1 b1 c1 n1 a2 b2 c2 n2]';

[p1,p2,P1_l,P2_l] = hmgLin2hmgPnts(l);

simplify(P1_l - jacobian(p1,l))
simplify(P2_l - jacobian(p2,l))









