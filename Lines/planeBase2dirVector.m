function [b,Ba,Bbeta] = planeBase2dirVector(a,beta)

% PLANEBASE2DIRVECTOR  Plucker line dir. vector from base spec.
%   B = PLANEBASE2DIRVECTOR(A,BETA) is a director 3-vector in the plane
%   normal to A and passing through the origin. The direction of the vector
%   is given in the plane reference frame by 2-vector BETA. The orthonormal
%   base in this plane is defined from the vector A with
%   PLANEVEC2PLANEBASE. It is required for A to be a unit vector.
%
%   [B,Ba,Bbeta] = ... returns the Jacobians of B wrt A and BETA.
%
%   See also PLANEVEC2PLANEBASE.

E = planeVec2planeBase(a);

b = E*beta;

if nargout > 1

    [a1,a2,a3] = split(a);
    [b1,b2]    = split(beta);

    a12n  = (a1^2+a2^2)^(1/2);
    a12n3 = a12n^3;

    Ba = [...
        [ -a2*(b1*a1-a3*b2*a2)/a12n3, a1*(b1*a1-a3*b2*a2)/a12n3,   a1/a12n*b2]
        [ -a2*(b1*a2+a1*a3*b2)/a12n3, a1*(b1*a2+a1*a3*b2)/a12n3,   a2/a12n*b2]
        [                -a1/a12n*b2,               -a2/a12n*b2,            0]];

    Bbeta = E;

end

return

%%

syms a1 a2 a3 b1 b2 real
a = [a1;a2;a3];
beta = [b1;b2];

[b,Ba,Bb] = planeBase2dirVector(a,beta);

simplify(Ba - jacobian(b,a))
simplify(Bb - jacobian(b,beta))

