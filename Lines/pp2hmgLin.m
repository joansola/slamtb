function [l,Lp,Lq] = pp2hmgLin(p,q)

% PP2HMGLIN  Homogeneous line from two homogeneous points
%   PP2HMGLIN(P,Q) is the homogeneous line in the projective plane joining the
%   two  points P and Q. P and Q can be either Euclidean 2-points or
%   homogeneous 3-points.
%
%   [L,Lp,Lq] = PP2HMGLIN(p,q) returns the Jacobians wrt P and Q.
%
%   See also CROSSJ, HH2P.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargout == 1
    if numel(p) == 2 % Support for Euclidean points
        p = euc2hmg(p);
        q = euc2hmg(q);
    end
    l = cross(p,q);
else
    if numel(p) == 2 % Support for Euclidean points
        [p,Pp] = euc2hmg(p);
        [q,Qq] = euc2hmg(q);
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
[l,Lp,Lq]=pp2hmgLin(p,q);
Lp-jacobian(l,p)
Lq-jacobian(l,q)

%% Homogeneous
p=[p1;p2;p3];
q=[q1;q2;q3];
[l,Lp,Lq]=pp2hmgLin(p,q);
Lp-jacobian(l,p)
Lq-jacobian(l,q)









