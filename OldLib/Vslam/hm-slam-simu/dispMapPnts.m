% DISPMAPPNTS  display map points

% points
usedPnts = [Lmk.Pnt.used]; % used points
uloc = [Lmk.Pnt(usedPnts).loc];

% ellipses
for i = 1:Lmk.maxPnt
    if usedPnts(i)
        r = loc2range(Lmk.Pnt(i).loc);
        x = Map.X(r);
%         if i == 2, 
%             x, 
%             Lmk.Pnt(i).front, 
%         end
        P = Map.P(r,r);
        [e,Ex] = hm2eu(x);
        E = Ex*P*Ex';
        [ellix,elliy,elliz] = cov3elli(e,E,ns,16);
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
    uX   = reshape(Map.X(urng),HDIM,[]);
    uXx = uX(1,:)./uX(4,:);
    uXy = uX(2,:)./uX(4,:);
    uXz = uX(3,:)./uX(4,:);
else
    uXx = [];
    uXy = [];
    uXz = [];
end
set(dispMapPnt.center,'xdata',uXx,'ydata',uXy,'zdata',uXz);


