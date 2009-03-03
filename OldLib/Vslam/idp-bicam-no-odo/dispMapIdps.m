function dispMapIdp = dispMapIdps(dispMapIdp,ns)

% DISPMAPIDPS  display map inverse depth points

global Map Lmk IDIM

% idps
usedIdps = [Lmk.Idp.used]; % used idps
uloc = [Lmk.Idp(logical(usedIdps)).loc];

% centers
if ~isempty(uloc)
    urng = loc2range(uloc);
    idp  = reshape(Map.X(urng),IDIM,[]);
    p = idp2p(idp);
    uXx = p(1,:);
    uXy = p(2,:);
    uXz = p(3,:);

else
    uXx = [];
    uXy = [];
    uXz = [];
end
set(dispMapIdp.center,'xdata',uXx,'ydata',uXy,'zdata',uXz);

% ellipses
elli{Lmk.maxIdp,3} = [];
ellitxt{Lmk.maxIdp,2} = '';
for i = 1:Lmk.maxIdp
    if ~isempty(usedIdps) && usedIdps(i)
        r = loc2range(Lmk.Idp(i).loc);
        idp = Map.X(r);
        IDP = Map.P(r,r);
        [elli{i,1},elli{i,2},elli{i,3}] = idp3elli(idp,IDP,ns,16);
        ellitxt{i,1} = num2str(Lmk.Idp(i).id); % identifier
        ellitxt{i,2} = idp2p(idp)+[0;.5;.5];

    else
        [elli{i,1},elli{i,2},elli{i,3}] = deal([]);%deal(zeros(1,34));
        ellitxt{i,1} = ''; % no identifier
        ellitxt{i,2} = [1;1;1];

    end
    

end
set(dispMapIdp.elli,{'xdata','ydata','zdata'},elli)
set(dispMapIdp.txt,{'string','position'},ellitxt)


