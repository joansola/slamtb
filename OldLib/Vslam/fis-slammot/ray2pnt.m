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
Ray.used    = false;

% Transfer Ray info to Pnt
Pnt.id      = Ray.id;
Pnt.used    = true;
Pnt.loc     = Ray.loc(1);
Pnt.sig     = Ray.sig;
Pnt.wPatch  = Ray.wPatch;
Pnt.Robi    = Ray.Robi;
Pnt.vis0    = Ray.vis0;
Pnt.dUmax   = Ray.dUmax;
Pnt.matched = Ray.matched;
Pnt.updated = Ray.updated;
Pnt.lost    = Ray.lost;
Pnt.found   = Ray.found;
Pnt.lostTh  = lostTh;

for cam = 1:2
    Pnt.Prj(cam).Hr      = Ray.Prj(cam).Hr(:,:,1);
    Pnt.Prj(cam).Hc      = Ray.Prj(cam).Hc(:,:,1);
    Pnt.Prj(cam).Hp      = Ray.Prj(cam).Hp(:,:,1);
    Pnt.Prj(cam).front   = Ray.Prj(cam).front(1);
    Pnt.Prj(cam).vis     = Ray.Prj(cam).vis0;
    Pnt.Prj(cam).dU      = Ray.Prj(cam).dU(1);
    Pnt.Prj(cam).matched = Ray.Prj(cam).matched;
    Pnt.Prj(cam).updated = Ray.Prj(cam).updated;
    Pnt.Prj(cam).lost    = Ray.Prj(cam).lost;
    Pnt.Prj(cam).found   = Ray.Prj(cam).found;
    Pnt.Prj(cam).y       = Ray.Prj(cam).y;
    Pnt.Prj(cam).s       = Ray.Prj(cam).s(1);
    Pnt.Prj(cam).sr      = Ray.Prj(cam).sr(1);
    Pnt.Prj(cam).u       = Ray.Prj(cam).u(:,1);
    Pnt.Prj(cam).U       = Ray.Prj(cam).U(:,:,1);
    Pnt.Prj(cam).dU      = Ray.Prj(cam).dU(1);
    Pnt.Prj(cam).z       = Ray.Prj(cam).z(:,1);
    Pnt.Prj(cam).Z       = Ray.Prj(cam).Z(:,:,1);
    Pnt.Prj(cam).iZ      = Ray.Prj(cam).iZ(:,:,1);
    Pnt.Prj(cam).MD      = Ray.Prj(cam).MD(1);
    Pnt.Prj(cam).region  = Ray.Prj(cam).region;
    Pnt.Prj(cam).cPatch  = Ray.Prj(cam).cPatch;
    Pnt.Prj(cam).sc      = Ray.Prj(cam).sc;
    
end
