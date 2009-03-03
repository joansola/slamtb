function [Idp,Pnt] = idp2pnt(Idp,Pnt,lostTh)

% IDP2PNT  Idp to point transition
%   [IDP,PNT] = IDP2PNT(IDP,PNT,LTH) takes the first inverse depth point
%   IDP and  transfers it to a single point type landmark PNT by updating
%   IDP and PNT structures. LTH is the threshold for deleting a point after
%   LTH times without observing it (lost point).
%
%   IDP2PNT also converts the IDP into a PNT and updates the SLAM Map.
%
%   See also MOVELANDMARK, GETLOC

global Map

% delete idp from Idp
Idp.used    = false;

% Compute 3D point from idp
ir  = loc2range(Idp.loc);
m   = Map.m;
mr  = [1:ir(1)-1 ir(3)+1:ir(4)-1 ir(6)+1:m]; % non-idp range
idp = Map.X(ir);
Pii = Map.P(ir,ir);
Pim = Map.P(ir,mr);
[p,Pidp]     = idp2p(idp);
Ppp          = Pidp*Pii*Pidp';



% Transfer Idp info to Pnt
Pnt.id      = Idp.id;
Pnt.used    = true;
Pnt.loc     = Idp.loc(1);
Pnt.sig     = Idp.sig;
Pnt.wPatch  = Idp.wPatch;
Pnt.Robi    = Idp.Robi;
Pnt.vis0    = Idp.vis0;
Pnt.dUmax   = Idp.dUmax;
Pnt.matched = Idp.matched;
Pnt.updated = Idp.updated;
Pnt.lost    = Idp.lost;
Pnt.lostTh  = lostTh;

% Update map
pr           = loc2range(Pnt.loc);
Map.X(pr)    = p;
Map.P(pr,mr) = Pidp*Pim;
Map.P(mr,pr) = Map.P(pr,mr)';
Map.P(pr,pr) = Ppp;
liberateMap(Idp.loc(2));


for cam = 1:2
    Pnt.Prj(cam).Hr      = Idp.Prj(cam).Hr;
    Pnt.Prj(cam).Hc      = Idp.Prj(cam).Hc;
    Pnt.Prj(cam).Hp      = Idp.Prj(cam).Hi(:,1:3); % TODO check this
    Pnt.Prj(cam).front   = Idp.Prj(cam).front;
    Pnt.Prj(cam).vis     = Idp.Prj(cam).vis;
    Pnt.Prj(cam).dU      = Idp.Prj(cam).dU;
    Pnt.Prj(cam).matched = Idp.Prj(cam).matched;
    Pnt.Prj(cam).updated = Idp.Prj(cam).updated;
    Pnt.Prj(cam).lost    = Idp.Prj(cam).lost;
    Pnt.Prj(cam).y       = Idp.Prj(cam).y;
    Pnt.Prj(cam).s       = Idp.Prj(cam).s;
    Pnt.Prj(cam).sr      = Idp.Prj(cam).sr(1);
    Pnt.Prj(cam).u       = Idp.Prj(cam).u(:,1);
    Pnt.Prj(cam).U       = Idp.Prj(cam).U(:,:,1);
    Pnt.Prj(cam).dU      = Idp.Prj(cam).dU(1);
    Pnt.Prj(cam).z       = Idp.Prj(cam).z(:,1);
    Pnt.Prj(cam).Z       = Idp.Prj(cam).Z(:,:,1);
    Pnt.Prj(cam).iZ      = Idp.Prj(cam).iZ(:,:,1);
    Pnt.Prj(cam).MD      = Idp.Prj(cam).MD(1);
    Pnt.Prj(cam).region  = Idp.Prj(cam).region;
    Pnt.Prj(cam).cPatch  = Idp.Prj(cam).cPatch;
    Pnt.Prj(cam).sc      = Idp.Prj(cam).sc;
    
end
