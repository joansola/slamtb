function [e,El,Es] = computeExt(L,s)

a   = L(1:3);
b   = L(4:6);
nb2 = dot(b,b);
nb  = sqrt(nb2);
bn  = normvec(b);
an  = a/nb;
p0  = cross(bn,an);
e   = p0 + s*bn;

if nargout > 1

    El(1,2) = -b(3)/nb2;
    El(1,1) = 0;
    El(1,3) = b(2)/nb2;
    El(1,4) = -2*b(2)/nb2^2*a(3)*b(1)+2*b(3)/nb2^2*a(2)*b(1)+s/nb-s*b(1)^2/nb^3;
    El(1,5) = 1/nb2*a(3)-2*b(2)^2/nb2^2*a(3)+2*b(3)/nb2^2*a(2)*b(2)-s*b(1)/nb^3*b(2);
    El(1,6) = -2*b(2)/nb2^2*a(3)*b(3)-1/nb2*a(2)+2*b(3)^2/nb2^2*a(2)-s*b(1)/nb^3*b(3);
    El(2,1) = b(3)/nb2;
    El(2,2) = 0;
    El(2,3) = -b(1)/nb2;
    El(2,4) = -2*b(3)/nb2^2*a(1)*b(1)-1/nb2*a(3)+2*b(1)^2/nb2^2*a(3)-s*b(1)/nb^3*b(2);
    El(2,5) = -2*b(3)/nb2^2*a(1)*b(2)+2*b(2)/nb2^2*a(3)*b(1)+s/nb-s*b(2)^2/nb^3;
    El(2,6) = 1/nb2*a(1)-2*b(3)^2/nb2^2*a(1)+2*b(1)/nb2^2*a(3)*b(3)-s*b(2)/nb^3*b(3);
    El(3,1) = -b(2)/nb2;
    El(3,2) = b(1)/nb2;
    El(3,3) = 0;
    El(3,4) = 1/nb2*a(2)-2*b(1)^2/nb2^2*a(2)+2*b(2)/nb2^2*a(1)*b(1)-s*b(1)/nb^3*b(3);
    El(3,5) = -2*b(1)/nb2^2*a(2)*b(2)-1/nb2*a(1)+2*b(2)^2/nb2^2*a(1)-s*b(2)/nb^3*b(3);
    El(3,6) = -2*b(3)/nb2^2*a(2)*b(1)+2*b(3)/nb2^2*a(1)*b(2)+s/nb-s*b(3)^2/nb^3;

    Es = bn;
end



return

%%
syms a1 a2 a3 b1 b2 b3 s real
L=[a1;a2;a3;b1;b2;b3];
[e,El,Es] = computeExt(L,s);

El2 = (simplify(jacobian(e,L)))
Es2 = simplify(jacobian(e,s))