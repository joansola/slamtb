function dispMapPnt = dispMapPnts(dispMapPnt,ns)

% DISPMAPPNTS  display map points

global Map Lmk WDIM

% points
usedPnts = [Lmk.Pnt.used]; % used points
uloc = [Lmk.Pnt(logical(usedPnts)).loc];

% ellipses
for i = 1:Lmk.maxPnt
    if ~isempty(usedPnts) && usedPnts(i)
        r = loc2range(Lmk.Pnt(i).loc);
        x = Map.X(r);
        P = Map.P(r,r);
        [elli{i,1},elli{i,2},elli{i,3}] = cov3elli(x,P,ns,16);
        ellitxt = num2str(Lmk.Pnt(i).id); % identifier
        ellitxtpos = x+[0;.5;.5];

    else
        [elli{i,1},elli{i,2},elli{i,3}] = deal([]);
        ellitxt = ''; % no identifier
        ellitxtpos = [1;1;1];

    end
    
    set(dispMapPnt.txt(i),...
        'position',ellitxtpos,...
        'string',ellitxt)

end

set(dispMapPnt.elli,{'xdata','ydata','zdata'},elli)


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


