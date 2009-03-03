function [l,Lp,Lq] = pp2hm(p,q)

% PP2HM  Homogeneous line from two homogeneous points
%   PP2HM(P,Q) is the homogeneous line in the projective plane joining the
%   two  points P and Q. P and Q can be either Euclidean 2-points or
%   homogeneous 3-points.
%
%   [L,Lp,Lq] = PP2HM(p,q) returns the Jacobians wrt P and Q.
%
%   See also CROSSJ, HH2P.

% (c) 2008 Joan Sola @ LAAS-CNRS.

if nargout == 1
    if numel(p) == 2 % Support for Euclidean points
        p = eu2hm(p);
        q = eu2hm(q);
    end
    l = cross(p,q);
else
    if numel(p) == 2 % Support for Euclidean points
        [p,Pp] = eu2hm(p);
        [q,Qq] = eu2hm(q);
        [l,Lp,Lq] = crossJ(p,q);
        Lp = Lp*Pp;
        Lq = Lq*Qq;
    else
        [l,Lp,Lq] = crossJ(p,q);
    end
end

return

%% Jac
syms p1 p2 p3 q1 q2 q3 real

%% Euclidean
p=[p1;p2];
q=[q1;q2];
[l,Lp,Lq]=pp2hm(p,q);
Lp-jacobian(l,p)
Lq-jacobian(l,q)

%% Homogeneous
p=[p1;p2;p3];
q=[q1;q2;q3];
[l,Lp,Lq]=pp2hm(p,q);
Lp-jacobian(l,p)
Lq-jacobian(l,q)
