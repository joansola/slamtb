function Lmk = evalLmk(Rob,Cam,Lmk,Obs,MDth)

global Map

Lmk.pr = loc2range(Lmk.loc);
pe     = Map.X(Lmk.pr);
Lmk.ye = robCamPhoto(Rob,Cam,pe);

[Lmk.Hr,Lmk.Hc,Lmk.Hp] = robCamPhotoJac(Rob,Cam,pe);
[Lmk.z,Lmk.Z,Lmk.iZ]   = ...
    blockInnovation(Rob.r,Lmk.pr,Lmk.Hr,Lmk.Hp,Obs,Lmk.ye);
Lmk.dZ = det(Lmk.Z);
Lmk.MD = Lmk.z'*Lmk.iZ*Lmk.z;

if Lmk.MD > MDth
    Lmk.del = 1;
else
    Lmk.del = 0;
end

