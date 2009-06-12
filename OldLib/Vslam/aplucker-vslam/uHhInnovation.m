function Obs = uHhInnovation(Obs)


Obs.z = Obs.y - Obs.u;
Obs.Z = Obs.U + Obs.R;
Obs.iZ = Obs.Z^-1;
Obs.MD = Obs.z'*Obs.iZ*Obs.z;

