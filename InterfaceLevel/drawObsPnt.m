function drawObsPnt(SenFig, Obs, colors)

% DRAWOBSPNT  Redraw a landmark on the pinHole sensor figure.
%   DRAWOBSPNT(SENFIG, OBS, COLORS)  (re)draw a landmark on the pinHole
%   sensor figure SENFIG.
%
%   COLORS is a structure with the colors to apply to the point. Ex:
%     colors.predicted = 'b'; % blue for only predicted points
%     colors.updated   = 'c'; % cyan for updated points
%   OBS is the observation of the couple (landmark/sensor).
%


posOffset = [0;-15];

% the measurement:
if Obs.measured
    y = Obs.meas.y;
    set(SenFig.measure(Obs.lmk),...
        'xdata', y(1),...
        'ydata', y(2),...
        'color', colors.updated,...
        'vis',   'on');
else
    set(SenFig.measure(Obs.lmk),...
        'vis',   'off');
end

% the ellipse
if Obs.updated
    elliCol = colors.updated;
else
    elliCol = colors.predicted;
end

% draw ellipse and label
hnds.ellipse = SenFig.ellipse(Obs.lmk);
hnds.label   = SenFig.label(Obs.lmk);
drawGauss2dPnt(...
    hnds,...
    Obs.exp.e,...
    Obs.exp.E,...
    num2str(Obs.lid),...
    elliCol,...
    posOffset);



