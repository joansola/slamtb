function [s, S_l] = idpLin2seg(l)

if nargout == 1

    [e1, e2] = idpLin2idpPnts(l);
    p1 = idp2euc(e1);
    p2 = idp2euc(e2);
    s = [p1;p2];

else

    [e1, e2, E1_l, E2_l] = idpLin2idpPnts(l);
    [p1, P1_e1] = idp2euc(e1);
    [p2, P2_e2] = idp2euc(e2);
    s = [p1;p2];
    S_l = [P1_e1*E1_l ; P2_e2*E2_l];

end
