function a = vecsAngle(u,v)

% VECSANGLE  Angle between two vectors.
%   VECSANGLE(U,V) returns the angle between column vectors U and V. The
%   angle is defined between -pi/2 and pi/2.
%
%   VECSANGLE(M,V) returns a row vector with the m angles between the
%   colums of the n-by-m matrix M and the n-vector V.

%   Copyright 2008,2009,2010 Joan Sola @ LAAS-CNRS.


a = acos((u'*v)./sqrt((u'*u).*sum(v.^2)));
i = (a > pi/2);
a(i) = pi-a(i);
end











