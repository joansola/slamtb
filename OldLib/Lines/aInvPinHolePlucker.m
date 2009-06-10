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
    
    iauav = 1/au/av;
    iau2  = 1/au^2;
    iav2  = 1/av^2;
    d     = (u0*l1+v0*l2+l3);
    
    Ak = [...
        [        0,        0,          0,   -iav2*l1]
        [        0,        0,   -iau2*l2,          0]
        [ iauav*l1, iauav*l2, -d*iau2/av, -d/au*iav2]];

    Al = iK;

end

return

%% build jac

syms u0 v0 au av l1 l2 l3 real
k = [u0 v0 au av]';
l = [l1 l2 l3]';

a = aInvPinHolePlucker(k,l);

Ak1 = simplify(jacobian(a,k))
Al1 = simplify(jacobian(a,l))

%% test jac

syms u0 v0 au av l1 l2 l3 real
k = [u0 v0 au av]';
l = [l1 l2 l3]';

[a,Ak,Al] = aInvPinHolePlucker(k,l);

Ak1 = simplify(jacobian(a,k));
Al1 = simplify(jacobian(a,l));

simplify(Ak-Ak1)
simplify(Al-Al1)

