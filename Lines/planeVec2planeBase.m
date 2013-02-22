function E = planeVec2planeBase(n)

% PLANEVEC2PLANEBASE  Orthonormal base for a plane
%   E = PLANEVEC2PLANEBASE(N) is an orthonormal base E=[e1 e2] of a plane
%   normal to N and passing through the origin. N is required to be
%   normalized. The two vectors of the base are computed as follows
%
%       e1 = [-N(2);N(1);0]/norm(N(1:2))
%       e2 = cross(e1,N)

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


e1 = [n(2);-n(1);0]/sqrt(dot(n(1:2),n(1:2)));
e2 = cross(n,e1);
E  = [e1 e2];









