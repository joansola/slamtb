function drawRawPnts(SenFig,Raw)

if ~isempty(Raw.data.points.coord)
    set(SenFig.raw.points,...
        'xdata',Raw.data.points.coord(1,:),...
        'ydata',Raw.data.points.coord(2,:))
end
