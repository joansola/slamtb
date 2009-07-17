function drawRawPnts(SenFig,Raw)

% DRAWRAWPNTS  Draw raw lines.
%   DRAWRAWPNTS(SENFIG,RAW)  redraws the 2D points in RAW on figure SenFig.

if ~isempty(Raw.data.points.coord)
    set(SenFig.raw.points,...
        'xdata',Raw.data.points.coord(1,:),...
        'ydata',Raw.data.points.coord(2,:))
end
