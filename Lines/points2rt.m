function [rt,RTp,RTq] = points2rt(p,q)

% POINTS2RT  Points to rho theta 2D line conversion.
%   POINTS2RT(P,Q) is the rho-theta line in the plane joining the
%   two  points P and Q. P and Q can be either Euclidean 2-points or
%   homogeneous 3-points.
%  
%   [rt,RTp,RTq] = POINTS2RT(p,q) returns the Jacobians wrt P and Q.

%   (c) 2008 Joan Sola @ LAAS-CNRS

if nargout == 1
    
    rt = hm2rt(pp2hm(p,q));
    
else
    
    [l,Lp,Lq] = pp2hm(p,q);
    [rt,RTl]  = hm2rt(l);
    RTp = RTl*Lp;
    RTq = RTl*Lq;
    
end

return

%%

syms p1 p2 p3 q1 q2 q3 real

% Euclidean
p = [p1;p2];
q = [q1;q2];
[rt,RT_p,RT_q] = points2rt(p,q)

simplify(RT_p - jacobian(rt,p))
simplify(RT_q - jacobian(rt,q))
