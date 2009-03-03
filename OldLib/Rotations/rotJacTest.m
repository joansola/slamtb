%%
syms p q r real
syms x y z real
%%
v = [p q r]';
R = simple(v2R(v));
X = [x y z]';

X2 = R*X;

Jx = subexpr(simple(jacobian(X2,X)))
Jv = subexpr(simple(jacobian(X2,v)))