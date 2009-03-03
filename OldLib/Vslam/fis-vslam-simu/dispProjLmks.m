% DISPPROJLMKS  display projected landmark means

% points
usedPnts = [Lmk.Pnt.used];
pu = [Lmk.Pnt(usedPnts).u];
if ~isempty(pu)
    % centers
    pux = pu(1,:);
    puy = pu(2,:);
    % ellipses
    for i = 1:Lmk.maxPnt
        if usedPnts(i)
            u = Lmk.Pnt(i).u;
            Z = Lmk.Pnt(i).U + Obs.R;
            [ellix,elliy] = cov2elli(u,Z,ns,16);
        else
            ellix = [];
            elliy = [];
        end
        set(dispProjPnt.elli(i),...
            'xdata',ellix,...
            'ydata',elliy)
    end
else
    pux=[];
    puy=[];
end
set(dispProjPnt.center,'xdata',pux,'ydata',puy);

% rays
Ng = 1+ceil(log(((1-alpha)/(1+alpha))*((sMax)/(sMin)))/log(beta));
usedRays = [Lmk.Ray.used];
ru = [Lmk.Ray(usedRays).u0];
if ~isempty(ru)
    % centers
    rux = ru(1,:);
    ruy = ru(2,:);
    % ellipses
    e = 1;
    for i = 1:Lmk.maxRay
        for j = 1:Ng
            if any(lastUsedRays==i) && ...
                    (j < Lmk.Ray(i).n)
                u = Lmk.Ray(i).u(:,j);
                Z = Lmk.Ray(i).U(:,:,j) + Obs.R;
                [ellix,elliy] = cov2elli(u,Z,ns,16);
            else
                ellix = [];
                elliy = [];
            end
            set(dispProjRay.elli(e),...
                'xdata',ellix,...
                'ydata',elliy)
            e = e+1;
        end
    end
else
    rux=[];
    ruy=[];
end
set(dispProjRay.center,'xdata',rux,'ydata',ruy);

% image
set(dispImage,'cdata',Image);
