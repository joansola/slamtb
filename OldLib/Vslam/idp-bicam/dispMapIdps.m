function dispMapIdp = dispMapIdps(dispMapIdp,ns)

% DISPMAPIDPS  display map inverse depth points

global Map Lmk WDIM IDIM

% idps
usedIdps = [Lmk.Idp.used]; % used idps
uloc = [Lmk.Idp(logical(usedIdps)).loc];

% ellipses
for i = 1:Lmk.maxIdp
    if ~isempty(usedIdps) && usedIdps(i)
        r = loc2range(Lmk.Idp(i).loc);
        idp = Map.X(r);
        IDP = Map.P(r,r);
        [ellix,elliy,elliz] = idp3lim(idp,IDP,ns,16);
    else
        ellix = [];
        elliy = [];
        elliz = [];
    end
    set(dispMapIdp.elli(i),...
        'xdata',ellix,...
        'ydata',elliy,...
        'zdata',elliz)
end

% centers
if ~isempty(uloc)
    urng = loc2range(uloc);
    idp  = reshape(Map.X(urng),IDIM,[]);
    for i = 1:size(idp,2)
        p = idp2p(idp(:,i));
        uXx(i) = p(1,:);
        uXy(i) = p(2,:);
        uXz(i) = p(3,:);
    end
else
    uXx = [];
    uXy = [];
    uXz = [];
end
set(dispMapIdp.center,'xdata',uXx,'ydata',uXy,'zdata',uXz);


