% DISPPROJRAYS  display projected rays

% rays
visRays = [Lmk.Ray.used]&[Lmk.Ray.vis0];
ru = [Lmk.Ray(visRays).u0];
% ellipses
e = 1; % ellipse index
for i = 1:Lmk.maxRay
    clr = 'm';
    for j = 1:Ng
        if visRays(i) && (j <= Lmk.Ray(i).n) 
            if Lmk.Ray(i).updated == 1
                clr = 'r';
            end
            u = Lmk.Ray(i).u(:,j);
            Z = Lmk.Ray(i).U(:,:,j) + Obs.R;
            [ellix,elliy] = cov2elli(u,Z,ns,16); % ellipse line
        else
            ellix = [];
            elliy = []; % no ellipse
        end
        set(dispProjRay.elli(e),...
            'xdata',ellix,...
            'ydata',elliy,...
            'color',clr) % draw
        e = e+1; % incr index for next ellipse
        Lmk.Ray(i).updated = 0;
        Lmk.Ray(i).matched = 0;
    end
end

% centers
if ~isempty(ru)
    rux = ru(1,:);
    ruy = ru(2,:); % center points
else
    rux=[];
    ruy=[]; % no points
end
set(dispProjRay.center,'xdata',rux,'ydata',ruy); % draw


