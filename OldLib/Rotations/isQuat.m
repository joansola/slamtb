function b = isQuat(q)
% ISQUAT True if input argument is a quaternion

b = (all(size(q(:)) == [4 1])) && (abs(norm(q)-1) < 1e-6);
