function Camo = composeRobCam(Rob,Cam)

Camo = Cam;
F = composeFrames(Rob,Cam);
Camo.X = F.X;
Camo = updateFrame(Camo);
