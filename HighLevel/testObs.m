function Obs = testObs(Obs, pos, COV)

if (nargin<2)
    pos = [100;100];
end
if (nargin<3)
    COV = 6^2*eye(2) ;
end
 
Obs.meas.y = pos;
Obs.meas.R = COV;

Obs.exp.e = Obs.meas.y;
Obs.exp.E = Obs.meas.R;

Obs.measured = true;
Obs.matched  = true;
Obs.updated  = false;

Obs.vis = true;
