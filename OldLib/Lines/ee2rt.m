function rt = ee2rt(e1,e2)

u = normvec(e2-e1);
s0 = -dot(e1,u);
p0 = e1 + s0*u;

r = sqrt(dot(p0,p0));
t = atan(p0(2)/p0(1));

rt = [r;t];
return

%%

syms u1 v1 u2 v2 real
e1 = [u1;v1];
e2 = [u2;v2];
rt = ee2rt(e1,e2);

rt = simplify(rt)

RTe1 = simplify(jacobian(rt,e1))
RTe2 = simplify(jacobian(rt,e2))

