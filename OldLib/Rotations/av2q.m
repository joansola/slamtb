function q = av2q(a,v)
% WARNING Deprecated. Use AU2Q instead.
%
% AV2Q rotated angle and rotation axis vector to quaternion
%   Q = AV2Q(A,V) gives the quaternion representing a rotation
%   of A rad around the axis defined by the unity vector V

warning('Deprecated function. Use AU2Q instead')

q = au2q(a,v);