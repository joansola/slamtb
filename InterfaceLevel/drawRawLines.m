function drawRawLines(SenFig,Raw)

% DRAWRAWLINES  Draw raw lines.
%   DRAWRAWLINES(SENFIG,RAW)  redraws the 2D segments in RAW on figure
%   SenFig.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if ~isempty(Raw.data.segments.coord)
    
    m = size(Raw.data.segments.coord,2); % number of segments
    pn = {'xdata','ydata'};
    pv = mat2cell(Raw.data.segments.coord([1 3 2 4],:)',ones(1,m),[2 2]);
    
    set(SenFig.raw.segments(1:m),...
        pn,     pv,...
        'vis',  'on')
    set(SenFig.raw.segments(m+1:end),...
        'vis',  'off')
    
end









