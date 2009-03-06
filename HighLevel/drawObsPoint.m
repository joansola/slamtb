function drawObsPoint(SenFig, Obs, colors)

% DRAWOBSPOINT(SENFIG, OBS, COLORS)  (re)draw a landmark on the pinHole sensor figure.
%
% COLORS is the colors witch apply to the point figure. ex:
%    colors = ['m' 'r']; % magenta/red or
%    colors = ['b' 'c']; % blue/cyan
% OBS is the observation of the couple (landmark/sensor).
%


visible = {'off','on'};
posOffset = [0;0];


% the measurement:
y = Obs.meas.y;
set(SenFig.measure,...
    'xdata', y(1),...
    'ydata', y(2),...
    'color', colors(1),...
    'vis',   visible{1+Obs.measured});

% the ellipse
[X,Y] = cov2elli(Obs.exp.e, Obs.exp.E, 3, 10) ;
set(SenFig.ellipse,...
    'xdata', X,...
    'ydata', Y,...
    'color', colors(1+Obs.updated),...
    'vis',   'on');

% the label
pos = Obs.exp.e + posOffset;
set(SenFig.label,...
    'position', pos,...
    'vis',      'on');




