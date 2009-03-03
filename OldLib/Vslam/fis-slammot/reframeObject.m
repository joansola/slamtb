function Obj = reframeObject(Obj,Odo)

% Obj = reframeObject(Obj,Odo)

[Obj.x,Jo,Ju] = reframe(Obj.x,Odo.u);
Obj.P = Jo*Obj.P*Jo' + Ju*Odo.U*Ju';

