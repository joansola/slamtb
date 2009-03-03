function dispMapPnt = dispMapPnts(dispMapPnt,ns)

% DISPMAPPNTS  display map points

global Map Lmk WDIM

% points
usedPnts = [Lmk.Pnt.used]; % used points
uloc = [Lmk.Pnt(find(usedPnts)).loc];

% ellipses
for i = 1:Lmk.maxPnt
    if ~isempty(usedPnts) && usedPnts(i)
        r = loc2range(Lmk.Pnt(i).loc);
        x = Map.X(r);
        P = Map.P(r,r);
        [ellix,elliy,elliz] = cov3elli(x,P,ns,16);
    else
        ellix = [];
        elliy = [];
        elliz = [];
    end
    set(dispMapPnt.elli(i),...
        'xdata',ellix,...
        'ydata',elliy,...
        'zdata',elliz)
end

% centers
if ~isempty(uloc)
    urng = loc2range(uloc);
    uX   = reshape(Map.X(urng),WDIM,[]);
    uXx = uX(1,:);
    uXy = uX(2,:);
    uXz = uX(3,:);
else
    uXx = [];
    uXy = [];
    uXz = [];
end
set(dispMapPnt.center,'xdata',uXx,'ydata',uXy,'zdata',uXz);


