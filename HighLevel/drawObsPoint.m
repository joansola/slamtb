function drawObsPoint(measureFig, ellipseFig, labelFig, colors, measured, updated, Obs)
% DRAWPINHOLELMK ()  (re)draw a landmark on the pinHole sensor figure.

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


