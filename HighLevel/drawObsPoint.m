function drawObsPoint(measureFig, ellipseFig, labelFig, colors, measured, updated, Obs)
% DRAWOBSPOINT(MEASUREFIG, ELLIPSEFIG, LABELFIG, COLORS, MEASURED, UPDATED,
% OBS)  (re)draw a landmark on the pinHole sensor figure.
%
% MEASUREFIG is the Figure where we have the measurement
% ELLIPSEFIG is the figure with the ellipse
% LABELFIG is the figure with the label
% COLORS is the colors witch apply to the point figure. ex:
%    colors = ['m' 'r']; % magenta/red or
%    colors = ['b' 'c']; % blue/cyan
% MEASURED,UPDATED are boolean for the state of the landmark
% OBS is the observation of the couple (landmark/sensor).
%
%

visible = {'off','on'};
posOffset = [0;0];


                            % the measurement:
                            y = Obs.meas.y;
                            set(measureFig,...
                                'xdata', y(1),...
                                'ydata', y(2),...
                                'color', colors(1),...
                                'vis',   visible{1+measured});

                            % the ellipse
                            [X,Y] = cov2elli(Obs.exp.e, Obs.exp.E, 3, 10) ;
                            set(ellipseFig,...
                                'xdata', X,...
                                'ydata', Y,...
                                'color', colors(1+updated),...
                                'vis',   'on');

                            % the label
                            pos = Obs.exp.e + posOffset;
                            set(labelFig,...
                                'position', pos,...
                                'vis',      'on');



end


