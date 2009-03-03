% DISPMAPRAYS  display map rays

% rays
usedRays = [Lmk.Ray.used];
nTerms = sum([Lmk.Ray(usedRays).n]);
uloc = zeros(1,nTerms);

% ellipses
term = 1;
e = 1;
for i = 1:Lmk.maxRay
    for j = 1:Ng
        if usedRays(i) && ...
                (j <= Lmk.Ray(i).n)
            loc = Lmk.Ray(i).loc(j);
            r = loc2range(loc);
            x = Map.X(r);
            P = Map.P(r,r);
            [ellix,elliy,elliz] = cov3elli(x,P,ns,16);
            uloc(term) = loc;
            term = term+1;
       else
            ellix = [];
            elliy = [];
            elliz = [];
        end
        set(dispMapRay.elli(e),...
            'xdata',ellix,...
            'ydata',elliy,...
            'zdata',elliz)
        e = e+1;
    end
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
set(dispMapRay.center,'xdata',uXx,'ydata',uXy,'zdata',uXz);


