function	[rot]=vecs2rot(v1,v2)

% VECS2ROT  Rotation matrix for rotating v2 to lie parallel to v1
%
% Vectors represented by x,y,z point. Can't be zero vectors.

% normalize
v1n = norm(v1);
v2n = norm(v2);
v1 = v1/v1n;
v2 = v2/v2n;

% cross vector
vc = cross(v2,v1);
vcn = norm(vc);
% norm is zero if parallel

if vcn > 1e-8
    ang = atan2(vcn,dot(v1,v2));
    rot = vc * ang / vcn;

    rot = rodrigues(rot);
else
    rot = eye(3);
end


