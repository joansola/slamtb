function [p1,p2,P1_l,P2_l] = ahmLin2ahmPnts(l)

% AHMLIN2AHMPNTS  AHM line to two AHM points conversion.
%   [P1,P2] = AHMLIN2AHMPNTS(L) extracts the two endpoints of the AHM line
%   L in the form of two HMG points with the same anchor of that of the
%   line.
%
%   [p1,p2,P1_l,P2_l] = AHMLIN2AHMPNTS(...) returns the Jacobians wrt L.

%   Copyright 2009 Teresa Vidal.

p1 = l(1:7,:);
p2 = l([1:3 8:11],:);

if nargout > 2

    P1_l = [eye(7) zeros(7,4)];
    P2_l = [eye(3) zeros(3,8) ; zeros(4,7) eye(4)];

end

return

%% jac

syms x y z a1 b1 c1 n1 a2 b2 c2 n2 real
l = [x y z a1 b1 c1 n1 a2 b2 c2 n2]';

[p1,p2,P1_l,P2_l] = ahmLin2ahmPnts(l);

simplify(P1_l - jacobian(p1,l))
simplify(P2_l - jacobian(p2,l))









