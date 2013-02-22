function [p1,p2,P1_l,P2_l] = idpLin2idpPnts(l)

% IDPLIN2IDPPNTS  IDP line to two IDP points conversion.
%   [P1,P2] = IDPLIN2IDPPNTS(L) extracts the two endpoints of the IDP line
%   L in the form of two IDP points with the same anchor of that of the
%   line.
%
%   [p1,p2,P1_l,P2_l] = IDPLIN2IDPPNTS(...) returns the Jacobians wrt L.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

p1 = l(1:6,:);
p2 = l([1:3 7:9],:);

if nargout > 2

    P1_l = [eye(6) zeros(6,3)];
    P2_l = [eye(3) zeros(3,6) ; zeros(3,6) eye(3)];

end

return

%% jac

syms x y z p1 y1 r1 p2 y2 r2 real
l = [x y z p1 y1 r1 p2 y2 r2]';

[p1,p2,P1_l,P2_l] = idpLin2idpPnts(l);

simplify(P1_l - jacobian(p1,l))
simplify(P2_l - jacobian(p2,l))









