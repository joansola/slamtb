function drawObsPoint(SenFig, Obs, colors)

% DRAWOBSPOINT  Redraw a landmark on the pinHole sensor figure.
%   DRAWOBSPOINT(SENFIG, OBS, COLORS)  (re)draw a landmark on the pinHole sensor figure.
%
%   COLORS is the colors witch apply to the point figure. ex:
%    colors = ['m' 'r']; % magenta/red or
%    colors = ['b' 'c']; % blue/cyan
%   OBS is the observation of the couple (landmark/sensor).
%


posOffset = [0;-15];

% the measurement:
if Obs.measured
    y = Obs.meas.y;
    set(SenFig.measure(Obs.lmk),...
        'xdata', y(1),...
        'ydata', y(2),...
        'color', colors(2,:),...
        'vis',   'on');
else
    set(SenFig.measure(Obs.lmk),...
        'vis',   'off');
end

% the ellipse
[X,Y] = cov2elli(Obs.exp.e, Obs.exp.E+Obs.meas.R, 3, 10) ;
set(SenFig.ellipse(Obs.lmk),...
    'xdata', X,...
    'ydata', Y,...
    'color', colors(1+Obs.updated,:),...
    'vis',   'on');

% the label
pos = Obs.exp.e + posOffset;
set(SenFig.label(Obs.lmk),...
    'position', pos,...
    'string',   num2str(Obs.lid),...
    'vis',      'on');




