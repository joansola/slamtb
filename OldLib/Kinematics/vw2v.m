function v = vw2v(v,w,dt)

% VW2V Rotation vector update from angular rates over time.
%   V = VW2V(V,W,DT) performs a one time step update of the rotation vector
%   V of a body with local angular rates W during a time DT. This is the
%   tustin integration of the equation:
%
%       dV/dt = f(v,w)
%
%   over a time interval DT.
%
%   See also QW2Q

u = sqrt(v'*v);
u2 = u/2;
su2 = sin(u2);
cu2 = cos(u2);

a = u*cu2 - 2*su2;

G = su2/(2*u)*[v';2*eye(3)] + a/(2*u^3)*[0 0 0;v*v'];

v1 = v(1);
v2 = v(2);
v3 = v(3);

W = 1/u*[-v1*su2  v1*cu2 -v3*su2  v2*su2
         -v2*su2  v3*su2  v2*cu2 -v1*su2
         -v3*su2 -v2*su2  v1*su2  v3*cu2];
     
V = W*G;

v = v + 0.5*dt*V'*w;
