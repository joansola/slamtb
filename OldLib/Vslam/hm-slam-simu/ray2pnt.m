function [Ray,Pnt] = ray2pnt(Ray,Pnt,lostTh)

% RAY2PNT  Ray to point transition
%   [RAY,PNT] = RAY2PNT(RAY,PNT,LTH) takes the first point of
%   the RAY and  transfer it to a single point type landmark PNT
%   by updating RAY and PNT structures. LTH is the threshold for
%   deleting a point after LTH times without observing it (lost
%   point)
%
%   See also MOVELANDMARK, GETLOC

% delete ray from Ray
Ray.used   = false;

% Transfer Ray info to Pnt
Pnt.used   = true;
Pnt.id     = Ray.id;
Pnt.sig    = Ray.sig;
Pnt.cPatch = Ray.cPatch;
Pnt.wPatch = Ray.wPatch;
Pnt.Robi   = Ray.Robi;

Pnt.sc     = Ray.sc;
Pnt.sch    = Ray.sch;
Pnt.scp    = Ray.scp;
Pnt.scl    = Ray.scl;
Pnt.scavg  = Ray.scavg;
Pnt.scstd  = Ray.scstd;

Pnt.loc    = Ray.loc(1);
Pnt.front  = Ray.front(1);
Pnt.vis    = Ray.vis(1);
Pnt.y      = Ray.y;
Pnt.Hr     = Ray.Hr(:,:,1);
Pnt.Hc     = Ray.Hc(:,:,1);
Pnt.Hp     = Ray.Hp(:,:,1);
Pnt.s      = Ray.s(1);
Pnt.u      = Ray.u(:,1);
Pnt.U      = Ray.U(:,:,1);
Pnt.dU     = Ray.Hr(1);
Pnt.z      = Ray.z(:,1);
Pnt.Z      = Ray.Z(:,:,1);
Pnt.iZ     = Ray.iZ(:,:,1);
Pnt.MD     = Ray.MD(1);

Pnt.front  = Ray.front(1);
Pnt.vis    = Ray.vis(1);

Pnt.matched = Ray.matched;
Pnt.updated = Ray.updated;
Pnt.lost   = Ray.lost;
Pnt.lostTh = lostTh;
Pnt.region = Ray.region;
