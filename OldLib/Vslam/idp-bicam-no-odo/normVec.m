function nv = normVec(v)

% NORMVEC Normalize a vector to unit length
%   Only works for column vectors

nv = v/sqrt(v'*v);

