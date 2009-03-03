function Obj = createObject(Obj,Cam,Obs,Depth,Vel,Pert,patchSize,lostObjTh)

% Obj = createObject(Obj,Cam,Obs,Depth,Vel,Pert,patchSize,lostObjTh)

global Map BDIM WDIM

% Point usage
Obj.used = true;
Obj.found = 1;
Obj.lost = 0;

% signature patch from left camera
Obj.sig = pix2patch(1,Obs(1).y,patchSize);
Obj.wPatch = Obj.sig;

% Observation things
Obj.lost = 0;

% In camera 1
Obj.Prj(1).y        = Obs(1).y;
Obj.Prj(1).u        = Obs(1).y;
Obj.Prj(1).U        = zeros(2);
Obj.Prj(1).Z        = Obs(1).R;
Obj.Prj(1).matched  = 1;
Obj.Prj(1).updated  = 1;
Obj.Prj(1).vis      = 1;

% Init from camera 1
[Gc,Gb,Gs] = invCamPhotoJac(Cam(1),Obs(1).y,Depth.s);

r   = invCamPhoto(Cam(1),Obs(1).y,Depth.s);
Pr  = Gb*Obs(1).R*Gb' + Gs*Depth.S*Gs';

v   = Vel.v;
Pv  = Vel.P;

Z3      = zeros(WDIM);

Obj.x   = [r;v];
Obj.P   = [Pr Z3;Z3 Pv];

% Projection into camera 2
[u,s,f] = camPhoto(Cam(2),r);
[Hc,Hr] = camPhotoJac(Cam(2),r);
Hc      = Hc(:,Cam(2).or);
Pc      = Map.P(Cam(2).r,Cam(2).r);
Ur      = Hr*Pr*Hr';
Uc      = Hc*Pc*Hc';
U       = Uc + Ur;

% results in camera 2
Obj.Prj(2).u  = u;     % Projection or expectation
Obj.Prj(2).U  = U;     % Expectation's covariances matrices
Obj.Prj(2).dU = det(U);% det. of Expectation's covariance
Obj.Prj(2).Z  = U + Obs(2).R; % Innovation covariance
Obj.Prj(2).s  = s; 
Obj.Prj(2).front    = f; 
Obj.Prj(2).matched  = false; 
Obj.Prj(2).updated  = false; 
Obj.Prj(2).vis      = 1; 
Obj.Prj(2).Hc       = Hc; 
Obj.Prj(2).Ho       = [Hr zeros(BDIM,WDIM)]; 



Obj.vis0   = true;
Obj.lostTh = lostObjTh;

% Perturbation levels
Obj.w = Pert.w;
Obj.W = Pert.W;


% Initial things TODO
