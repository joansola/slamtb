function [hh,HH_hm,HH_s] = hms2hh(hm,seg)

% HMS2HH  Orthogonal endpoints innovation for homogeneous line and segment.
%   HMS2HH(HM,SEG) is a 2-vector with the orthogonal distances from the two
%   extremes of the segment SEG to the homogeneous line HM.
%
%   [HH,HH_hm,HH_s] = ... returns the Jacobians wrt HM and SEG.

p = seg(1:2);
q = seg(3:4);

if nargout == 1

    hp = lp2d(hm,p);
    hq = lp2d(hm,q);

    hh = [hp;hq];

else

    [hp,HP_hm,HP_p] = lp2d(hm,p);
    [hq,HQ_hm,HQ_q] = lp2d(hm,q);

    hh = [hp;hq];

    Z = zeros(1,2);

    HH_hm = [HP_hm;HQ_hm];
    HH_s  = [HP_p Z;Z HQ_q];

end

return

%% jac

syms a b c u1 u2 v1 v2 real
hm = [a;b;c];
seg = [u1;v1;u2;v2];

[hh,HH_hm,HH_s] = hms2hh(hm,seg)

simplify(HH_hm - jacobian(hh,hm))
simplify(HH_s - jacobian(hh,seg))
