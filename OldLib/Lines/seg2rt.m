function [rt,RT_s] = seg2rt(seg)

% SEG2RT  Segment to rho-theta conversion.
%   SEG2RT(SEG) converts the segment SEG=[p1;p2] to the rho-theta line
%   representation.
%
%   [RT,RT_s] = SEG2RT(...) returns the Jacobian wrt SEG.

if nargout == 1

    rt = hm2rt(seg2hm(seg));
else

    [hm,HM_s] = seg2hm(seg);
    [rt,RT_hm] = hm2rt(hm);
    RT_s = RT_hm*HM_s;
    
end

return

%%
syms e1 e2 f1 f2 real
s = [e1;e2;f1;f2];

[rt,RT_s] = seg2rt(s)

simplify(RT_s - jacobian(rt,s))
