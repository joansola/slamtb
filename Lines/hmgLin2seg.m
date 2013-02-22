function [s, S_l] = hmgLin2seg(l)

%   HMGLIN2SEG HMG line to segment conversion
%   HMGLIN2SEG  returns a 3d segment with the two suppor points of the HMG
%   line L.
%
%   [s, S_l] = IDPLIN2SEG(L) returns the Jacobian wrt L.

%   Copyright 2009 Teresa Vidal.

if nargout == 1

    [e1, e2] = hmgLin2hmgPnts(l);
    p1       = hmg2euc(e1);
    p2       = hmg2euc(e2);

    s        = [p1;p2];

else

    [e1, e2, E1_l, E2_l] = hmgLin2hmgPnts(l);
    [p1, P1_e1]          = hmg2euc(e1);
    [p2, P2_e2]          = hmg2euc(e2);
    
    s   = [p1;p2];
    S_l = [P1_e1*E1_l ; P2_e2*E2_l];

end









