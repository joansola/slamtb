% DISPPROJPNTS  display projected points

% points
visPnts = [Lmk.Pnt.used] &[Lmk.Pnt.vis]; % visible points
pu = [Lmk.Pnt(visPnts).u];

% ellipses
for i = 1:Lmk.maxPnt
    clr = 'b';
    if visPnts(i)
        if Lmk.Pnt(i).updated == 1
            clr = 'c';
        end
        u = Lmk.Pnt(i).u;
        Z = Lmk.Pnt(i).U + Obs.R;
        [ellix,elliy] = cov2elli(u,Z,ns,16);
    else
        ellix = [];
        elliy = [];
    end
    set(dispProjPnt.elli(i),...
        'xdata',ellix,...
        'ydata',elliy,...
        'color',clr)
    Lmk.Pnt(i).updated = 0;
    Lmk.Pnt(i).matched = 0;
end

% centers
if ~isempty(pu)
    pux = pu(1,:);
    puy = pu(2,:);
else
    pux=[];
    puy=[];
end
set(dispProjPnt.center,'xdata',pux,'ydata',puy);


