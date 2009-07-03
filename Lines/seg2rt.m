function [rt,RT_s] = seg2rt(seg)

% SEG2RT Segment to rho-theta conversion.
%   SEG2RT(S) converts the segment S=[x1;y1;x2;y2] to its polar rho-theta
%   representation.
%
%   [RT, RT_s] = SEG2RT(S) returns the Jacobian of RT wrt S.
%
%   (c) 2009 Joan Sola @ LAAS-CNRS.

if nargout == 1
    
    rt = hmgLin2rt(seg2hmgLin(seg));
    
else
    
    [hm,HM_s] = seg2hmgLin(seg);
    [rt,RT_hm] = hmgLin2rt(hm);
    
    RT_s = RT_hm*HM_s;

end
