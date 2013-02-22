function H = homogeneous(f)

% HOMOGENEOUS Build motion matrix.
%   HOMOGENEOUS(F) Builds homogeneous motion matrix from frame F.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

[t,q,R] = splitFrame(f);

H = [R t;0 0 0 1];

end









