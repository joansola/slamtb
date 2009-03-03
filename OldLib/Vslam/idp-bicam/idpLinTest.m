function Ld = idpLinTest(Rob,Cam,Idp)

global Map

ir = loc2range(Idp.loc);

% explode idp:
idp = Map.X(ir);
x0  = idp(1:3);
py  = idp(4:5);
m   = py2vec(py);
rho = idp(6);

% and idp variance:
IDP = Map.P(ir,ir);
RHO = IDP(6,6);

rwc = fromFrame(Rob,Cam.t); % current camera center

hw   = x0-rwc;  % idp center to camera center
ss   = rho/RHO; % sigma in depth
s    = norm(hw);
cosa = m'*hw/s;

Ld = 4*ss/s*abs(cosa);

