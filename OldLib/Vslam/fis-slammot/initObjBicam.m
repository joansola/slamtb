function Obj = initObjBicam(Rob,Cam,Obj,vRay,Obs,Vel,Pert,alpha,patchSize,lostObjTh)

% Obtain one free object to host it
obj = getFree([Obj.used]);

% get 3d point - left camera frame
p3d = invBiCamPhoto(...
   Cam(1),...
   Cam(2),...
   Obs(1).y,...
   Obs(2).y);

% get depth
Depth.s = p3d(3);
Depth.S = (alpha*Depth.s)^2;

% Create object from camera 1
Obj(obj) = createObject(Obj(obj),Cam,Obs,Depth,Vel,Pert,patchSize,lostObjTh);
Obj(obj).Robi = Rob;

% Update with camera 2
Obj(obj) = uPntInnovation(Obj(obj),2,Obs(2).y,Obs(2).R);
Obj(obj) = correctObject(Cam(2),Obj(obj));


% Complete object values and flags
Obj(obj).Prj(2).y       = Obs(2).y;
Obj(obj).Prj(2).matched = 1;
Obj(obj).Prj(2).updated = 1;

