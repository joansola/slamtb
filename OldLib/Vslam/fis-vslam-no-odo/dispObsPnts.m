


% observations
% obsPnts = [Lmk.Pnt(visPnts).y];
matchedPnts = find([Lmk.Pnt.matched]);
obsPnts = [Lmk.Pnt(matchedPnts).y];
if isempty(obsPnts)
    obsPnts = zeros(2,0);
end
set(dispObsPnt,'xdata',obsPnts(1,:),'ydata',obsPnts(2,:));
