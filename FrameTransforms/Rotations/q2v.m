function v = q2v(q)

%Q2V Quaternion to rotation vector conversion.
%   Q2V(Q) transforms the quaternion Q into a rotation vector representing
%   the same rotation.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

[a,u] = q2au(q);
v = a*u;









