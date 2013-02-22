function drawObsPnt(SenFig, Obs, colors)

% DRAWOBSPNT  Redraw a landmark on the pinHole sensor figure.
%   DRAWOBSPNT(SENFIG, OBS, COLORS)  (re)draw a landmark on the pinHole
%   sensor figure SENFIG.
%
%   COLORS is a structure with the colors to apply to the point. Ex:
%     colors.predicted = 'b'; % blue for only predicted points
%     colors.updated   = 'c'; % cyan for updated points
%   OBS is the observation of the couple (landmark/sensor).

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.



posOffset = [0;-15];

% the measurement:
if Obs.measured
    y = Obs.meas.y;
    drawPnt(SenFig.measure(Obs.lmk),y,colors.updated)
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
drawEllipse(SenFig.ellipse(Obs.lmk), Obs.exp.e, Obs.exp.E + Obs.meas.R, elliCol)
drawLabel(SenFig.label(Obs.lmk), Obs.exp.e + posOffset, num2str(Obs.lid))









