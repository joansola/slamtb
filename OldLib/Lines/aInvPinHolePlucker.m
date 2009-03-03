function [a,Ak,Al] = aInvPinHolePlucker(k,l)

% AINVPINHOLEPLUCKER  Inverse pin hole model for Plucker lines
%   A = AINVPINHOLEPLUCKER(K,L) returns the director vector A of the plane
%   defined by the detected line L and the optical center in a camera with
%   intrinsic parameters K=[u0 v0 au av].
%
%   [A,Ak,Al] = ... returns the Jacobians wrt L and K.

iK = pluckerInvCamera(k);

a = iK*l;

if nargout > 1

    [u0,v0,au,av] = split(k);
    [l1,l2,l3]    = split(l);

    Ak = [...
        [          0,          0,                         0,                -1/av^2*l1]
        [          0,          0,                -1/au^2*l2,                         0]
        [ 1/au/av*l1, 1/av/au*l2, -(u0*l1+v0*l2+l3)/au^2/av, -(u0*l1+v0*l2+l3)/au/av^2]];

    Al = iK;

end

return

%%

syms u0 v0 au av l1 l2 l3 real
k = [u0 v0 au av]';
l = [l1 l2 l3]';

[a,Ak,Al] = aInvPinHolePlucker(k,l);

Ak1 = simplify(jacobian(a,k))
Al1 = simplify(jacobian(a,l))

