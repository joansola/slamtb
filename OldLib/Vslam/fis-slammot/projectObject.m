function Obj = projectObject(Cam,Obj,R)

% Obj = projectObject(Cam,Obj,R)

global BDIM WDIM Map

r = Obj.x(1:WDIM);
Pr = Obj.P(1:WDIM,1:WDIM);

% camera
cid = Cam.id; % identifier
cr = Cam.r; % range in map
cor = Cam.or; % self range
Pc = Map.P(Cam.r,Cam.r);

[u,s,f] = camPhoto(Cam,r);
[Hc,Hr] = camPhotoJac(Cam,r);
Hc = Hc(:,cor);

Uc = Hc*Pc*Hc';
Ur = Hr*Pr*Hr';
U  = Uc+Ur;

% get visible 
isze = Cam.imSize; % Image size in horizontal and vertical notation
mrg  = size(Obj.sig.I,1); % patch size pixels margin
inIm = inSquare(u,[0 isze(1) 0 isze(2)],mrg);
vis  = inIm & f;

Obj.Prj(cid).Hc    = Hc;
Obj.Prj(cid).Ho    = [Hr zeros(BDIM,WDIM)];
Obj.Prj(cid).u     = u;
Obj.Prj(cid).U     = U;
Obj.Prj(cid).dU    = det(U);
Obj.Prj(cid).Z     = U + R;
Obj.Prj(cid).s     = s;
Obj.Prj(cid).front = f;
Obj.Prj(cid).vis   = vis;



% Compare to initial things CHECK
% Pnt.Prj(cid).sr = s/Pnt.Prj(cam).si;

