function [e,t] = intersectPlucker(L,r)

% INTERSECTPLUCKER  Intersect Plucker lines, get point and abscissa.
%   INTERSECTPLUCKER(L,R)  intersects Plucker lines L and R and returns the
%   point in L that is closest to R.
%
%   [E,T] = INTERSECTPLUCKER(...) returns also the abscissa T so that
%
%       E = P0 + T*v(L)/norm(v(L))
%
%   where
%
%       P0   = LINEORIGIN(L) is the line's local origin
%       v(L) = L(4:6) is the lines director vector.
%
%   See also PLUCKERORIGIN.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


p0 = pluckerOrigin(L);
e  = lines2Epoint(L,r);

u  = normvec(L(4:6));

% solve the system e = p0 + t*u for variable t:
t = u'*(e - p0); % note that pinv(u) = u' because norm(u) = 1.










