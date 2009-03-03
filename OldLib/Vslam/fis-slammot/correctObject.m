function Obj = correctObject(Cam,Obj)

% CORRECTOBJECT  Object correction
%   OBJ = CORRECTOBJECT(CAM,OBJ) performs an EKF 
%   correction on object OBJ from previously computed innovation
%   parameters.

% Camera
cid = Cam.id;
Hc  = Obj.Prj(cid).Hc;

% object
Po  = Obj.P;
Ho  = Obj.Prj(cid).Ho;

% Innovations
z  = Obj.Prj(cid).z;
Z  = Obj.Prj(cid).Z;
iZ = Obj.Prj(cid).iZ;

% Kalman correction
K = Po*Ho'*iZ;
Obj.x = Obj.x + K*z;
Obj.P = Obj.P - K*Z*K';
