function [Obj,Pnt] = obj2pnt(Rob,Obj,Pnt,lostTh)

% OBJ2PNT  Obj to point transition
%   [OBJ,PNT] = OBJ2PNT(OBJ,PNT,LOC,LTH) takes the the object OBJ
%   and  transfer it to a single point type landmark PNT by
%   updating OBJ and PNT structures. LTH is the threshold for
%   deleting a point after LTH times without observing it (lost
%   point)
%
%   See also MOVELANDMARK, GETLOC

global Lmk Map PDIM CDIM VDIM WDIM

% TODO initPnt ben fet amb la info de l'objecte i les Jacobianes
% del robot que passen a la info pel punt correlat al mapa.

loc = getLoc();

or = loc2range(loc); % object's future range in the map
ml = find(Map.used); % used map locations
mr = loc2range(ml);  % range for used lmks
xr = [1:VDIM mr];    % total used map range


r = 1:WDIM; % object self-range
o = Obj.x(r); % object position - robot frame
Po = Obj.P(r,r); % object covariance - robot frame

rr = Rob.r; % robot range in the map

[Fr,Fo] = fromFrameJac(Rob,o); % Jacobians of transformation R2W

Map.X(or)    = fromFrame(Rob,o);
Map.P(or,or) = Fr*Map.P(rr,rr)*Fr' + Fo*Po*Fo';
Map.P(or,xr) = Fr*Map.P(rr,xr);
Map.P(xr,or) = Map.P(or,xr)';

occupateMap(loc);

% delete object from Obj
Obj.used    = false;

% Transfer Obj info to Pnt TODO
Pnt.id      = Obj.id;
Pnt.used    = true;
Pnt.loc     = loc;
Pnt.sig     = Obj.sig;
Pnt.wPatch  = Obj.wPatch;
Pnt.Robi    = Obj.Robi;
Pnt.vis0    = Obj.vis0;
Pnt.dUmax   = Obj.dUmax;
Pnt.matched = Obj.matched;
Pnt.updated = Obj.updated;
Pnt.lost    = Obj.lost;
Pnt.lostTh  = lostTh;

for cam = 1:2
%     Pnt.Prj(cam).Hr      = Obj.Prj(cam).Hr;
%     Pnt.Prj(cam).Hc      = Obj.Prj(cam).Hc;
%     Pnt.Prj(cam).Hp      = Obj.Prj(cam).Ho;
    Pnt.Prj(cam).front   = Obj.Prj(cam).front;
    Pnt.Prj(cam).vis     = Obj.Prj(cam).vis;
    Pnt.Prj(cam).matched = Obj.Prj(cam).matched;
    Pnt.Prj(cam).updated = Obj.Prj(cam).updated;
    Pnt.Prj(cam).lost    = Obj.Prj(cam).lost;
    Pnt.Prj(cam).y       = Obj.Prj(cam).y;
    Pnt.Prj(cam).s       = Obj.Prj(cam).s;
    Pnt.Prj(cam).sr      = Obj.Prj(cam).sr;
    Pnt.Prj(cam).u       = Obj.Prj(cam).u;
    Pnt.Prj(cam).U       = Obj.Prj(cam).U;
    Pnt.Prj(cam).dU      = Obj.Prj(cam).dU;
    Pnt.Prj(cam).z       = Obj.Prj(cam).z;
    Pnt.Prj(cam).Z       = Obj.Prj(cam).Z;
    Pnt.Prj(cam).iZ      = Obj.Prj(cam).iZ;
    Pnt.Prj(cam).MD      = Obj.Prj(cam).MD;
    Pnt.Prj(cam).region  = Obj.Prj(cam).region;
    Pnt.Prj(cam).cPatch  = Obj.Prj(cam).cPatch;
    Pnt.Prj(cam).sc      = Obj.Prj(cam).sc;
    
end
