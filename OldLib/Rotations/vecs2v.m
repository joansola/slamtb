function v = vecs2v(v1,v2)

% VECS2V  Rotation vector for rotating v2 to lie parallel to v1.
%
% Vectors are represented by x y z points.
% Can't be zero length.

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
    v = vc * ang / vcn;
else
    v = zeros(3,1);
end


