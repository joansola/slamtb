function [p,P_u,P_k,P_a] = uvd2hp(StHead,uvd)

% UVD2HP  Homogeneous point from disparity measurement
%   UVD2HP(SHEAD,UVD) computes the homogeneous point in 3D space
%   corresponding to the disparity measurement UVD = [u;v;d] taken from a
%   stereo head SHEAD. SHEAD is a structure containing
%       .cal  The [u0;v0;au;av] parameters of the left camera
%       .alpha The scale parameter so that z = alpha/d;
%
%   [P,P_u] = UVD2HP(...) returns the Jacobian of P wrt UVD.
%
%   [P,P_u,P_k,P_a] = UVD2HP(...) returns the Jacobians of HP wrt .cal,
%   .alpha and UVD.

[u0,v0,au,av] = split(StHead.cal);
a             = StHead.alpha;
[u,v,d]       = split(uvd);

x = (u-u0)*a/au;
y = (v-v0)*a/av;
z = a;
w = d;

p = [x;y;z;w];

switch nargout
    case 2 % only Jacobian wrt UVD
        
        P_u = [...
            [ a/au,    0,    0]
            [    0, a/av,    0]
            [    0,    0,    0]
            [    0,    0,    1]];

    case {3,4} % All Jacobians
        
        P_k = [...
            [          -a/au,              0, -(u-u0)*a/au^2,              0]
            [              0,          -a/av,              0, -(v-v0)*a/av^2]
            [              0,              0,              0,              0]
            [              0,              0,              0,              0]];
        
        P_a = [...
            (u-u0)/au
            (v-v0)/av
            1
            0];

        P_u = [...
            [ a/au,    0,    0]
            [    0, a/av,    0]
            [    0,    0,    0]
            [    0,    0,    1]];
end


return

%% jac

syms u0 v0 au av a u v d real
H.alpha = a;
H.cal = [u0 v0 au av];
uvd = [u;v;d];

p = uvd2hp(H,uvd)

P_k = jacobian(p,H.cal)
P_a = jacobian(p,H.alpha)
P_u = jacobian(p,uvd)
