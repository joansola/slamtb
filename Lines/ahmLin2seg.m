function [s, S_l] = ahmLin2seg(l)

% AHMLIN2SEG HMG line to segment conversion
%   AHMLIN2SEG(L)  returns a 3d segment with the two support points of the
%   HMG line L.
%
%   [s, S_l] = IDPLIN2SEG(L) returns the Jacobian wrt L.

%   Copyright 2009 Teresa Vidal.

if nargout == 1

    [e1, e2] = ahmLin2ahmPnts(l);
    p1       = ahm2euc(e1);
    p2       = ahm2euc(e2);

    s        = [p1;p2];

else

    [e1, e2, E1_l, E2_l] = ahmLin2ahmPnts(l);
    [p1, P1_e1]          = ahm2euc(e1);
    [p2, P2_e2]          = ahm2euc(e2);
    
    s   = [p1;p2];
    S_l = [P1_e1*E1_l ; P2_e2*E2_l];

end









