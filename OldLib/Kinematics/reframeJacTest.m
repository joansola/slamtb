syms x y z dx dy dz vx vy vz a b c real

r=[x y z]';
v=[vx vy vz]'; % state
dr=[dx dy dz]';
de=[a b c]'; % odometry

x=[r;v];
u=[dr;de];

xo = reframe(x,u);

Fx = simple(jacobian(xo,x));
Fu = simple(jacobian(xo,u));

ro=xo(1:3);
vo=xo(4:6);

Rr = simple(jacobian(ro,r))
Rv = simple(jacobian(ro,v))
Vr = simple(jacobian(vo,r))
Vv = simple(jacobian(vo,v))

Rdr = simple(jacobian(ro,dr))
Rde = simple(jacobian(ro,de))
Vdr = simple(jacobian(vo,dr))
Vde = simple(jacobian(vo,de))
