function region = countLmks(region)

% COUNTLMKS  Count landmarks (points and idps) in each region
%   R = COUNTLMKS(R) counts how many landmarks of global Lmk are 
%   inside each region in structure array R and returns it in the
%   appropiate fields of R
%     R.numPnt : number of points
%     R.numIdp : number of idps
%     R.numLmk : number of landmarks (points + rays)
%
%   See also COUNTRAYS, COUNTPNTS

% (c) 2005 Joan Sola

global Lmk

visPntsIdx = find([Lmk.Pnt.used]&[Lmk.Pnt.vis0]);
nVisPnts   = numel(visPntsIdx);
if nVisPnts ~= 0
    visPnts    = Lmk.Pnt(visPntsIdx);
    visPntsPrj = [visPnts.Prj];
    visPnts1   = visPntsPrj(1:2:end);
    pu         = [visPnts1.u];
else
    pu = [0;0];
end

visIdpsIdx = find([Lmk.Idp.used]&[Lmk.Idp.vis0]);
nVisIdps   = numel(visIdpsIdx);
if nVisIdps ~= 0
    visIdps    = Lmk.Idp(visIdpsIdx);
    visIdpsPrj = [visIdps.Prj];
    visIdps1   = visIdpsPrj(1:2:end);
    ru         = [visIdps1.u];
else
    ru = [0;0];
end
s = size(region.numLmk,2);

for i=1:s
    % region origin and size
    u0 = region.u0(:,i); 
    du = region.size(:,i);
    
    % check for points
    pu1ok = (pu(1,:) > u0(1)) & (pu(1,:) < u0(1)+du(1));
    pu2ok = (pu(2,:) > u0(2)) & (pu(2,:) < u0(2)+du(2));
    
    puok = pu1ok & pu2ok;
    spuok = sum(puok);

    region.numPnt(i) = spuok;
    
    % check for rays
    ru1ok = (ru(1,:) > u0(1)) & (ru(1,:) < u0(1)+du(1));
    ru2ok = (ru(2,:) > u0(2)) & (ru(2,:) < u0(2)+du(2));

    ruok = ru1ok & ru2ok;
    sruok = sum(ruok);

    region.numIdp(i) = sruok;
    
    % Total landmarks
    region.numLmk(i) = spuok + sruok;
end
