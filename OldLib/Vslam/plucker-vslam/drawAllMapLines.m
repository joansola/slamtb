function dispMapLines = drawAllMapLines(dispMapLines,Line,ns,drawEndPoins)

% DRAWALLMAPLINES  Draw all map lines

for i = 1:numel(Line)
    
    dispMapLines(i) = drawMapLine(dispMapLines(i),Line(i),ns,drawEndPoins);
    
end

    