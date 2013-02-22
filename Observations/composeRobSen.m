function Camo = composeRobSen(Rob,Cam)

%COMPOSEROBSEN Compose robot and sensor frames and parameters.
%   CSEN = COMPOSEROBSEN(ROB,SEN) composes ROB and SEN frames and then
%   copies all other info in SEN to get CSEN.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

Camo = Cam;
F = composeFrames(Rob.f,Cam.f);
Camo.f.X = F.X;
Camo.f = updateFrame(Camo.f);









