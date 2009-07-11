function handle = createSimLmkGraphics(SimLmk,colr,ax)

% CREATESIMLMKGRAPHICS  Crate simulated landmark graphics.
%   CREATESIMLMKGRAPHICS(SIMLMK,LBLCLR) creates the graphics objects for
%   the simulated landmarks SIMLMK. The function supports opints and
%   segments graphics, as specified by SIMLMK.opints and SIMLMK.segments.
%
%   CREATESIMLMKGRAPHICS(...,AX) creates the graphics at axes AX.
%
%   [PH,LH] = CREATESIMLMKGRAPHICS returns handles to the 'line' graphics
%   objects. PH for one 'line' object with all points. 'SH' for N 'line'
%   objects, one for each segment.

if nargin < 3
    ax = gca;
end

% points
if ~isempty(SimLmk.points.coord)
    ph = line(...
        'parent',       ax,...
        'xdata',        SimLmk.points.coord(1,:),...
        'ydata',        SimLmk.points.coord(2,:),...
        'zdata',        SimLmk.points.coord(3,:),...
        'color',        colr,...
        'linestyle',    'none',...
        'marker',       '+',...
        'markersize',   4);
else
    ph = line('vis','off');
end

% segments
if ~isempty(SimLmk.segments.coord)
    sh = drawSegmentsObject(SimLmk.segments.coord,colr,2);
else
    sh = [];
end

handle = [ph;sh];
