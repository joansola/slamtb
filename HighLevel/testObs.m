function Obs = testObs(Obs)


Obs.meas.y = [100;100];
Obs.meas.R = 6^2*eye(2);

Obs.exp.e = Obs.meas.y;
Obs.exp.E = Obs.meas.R;

Obs.measured = true;
Obs.matched  = true;
Obs.updated  = false;

Obs.vis = true;
