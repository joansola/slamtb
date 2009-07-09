function drawObsLin(SenFig, Obs, colors, imSize, SenOpt)

% DRAWOBSLIN  Redraw a line landmark on the pinHole sensor figure.
%   DRAWOBSLIN(SENFIG, OBS, COLORS, IMSIZE, SENOPT)  redraws a line
%   landmark on the pinHole sensor figure.
%
%   SENFIG is the sensor figure's handles structure.
%   OBS    is the landmark-sensor observation structure.
%   COLORS is a 3-by-1 vector of color identifiers for the measurement,
%   expectation mean, and endpoints covariance ellipses. For example
%       COLORS = ['b' 'g' 'y']'; % measurement in blue
%                                % expectation line in green
%                                % ellipses in yellow
%   IMSIZE is the image size [width,height].
%   SENOPT is the sensor figure options, SENOPT = FigOpt.sen.
%
%   See also DRAWOBSPNT, DRAWSENFIG, TRIMHMGLIN, COV2ELLI.

posOffset = 8;

% the measurement:
if Obs.measured
    y = Obs.meas.y;
    set(SenFig.measure(Obs.lmk),...
        'xdata', [y(1);y(3)],...
        'ydata', [y(2);y(4)],...
        'color', colors(1,:),...
        'vis',   'on');
    
    % the label
    c = (Obs.meas.y(1:2)+Obs.meas.y(3:4))*0.5; % segment's center
    v = (Obs.meas.y(1:2)-Obs.meas.y(3:4));     % segment's vector
    n = normvec([-v(2);v(1)]);          % segment's normal vector
    pos = c + n*posOffset;
    set(SenFig.label(Obs.lmk),...
        'position', pos,...
        'string',   num2str(Obs.lid),...
        'vis',      'on');

else
    set(SenFig.measure(Obs.lmk),...
        'vis',   'off');
    set(SenFig.label(Obs.lmk),'vis','off');
end

% the expectation
s = trimHmgLin(Obs.exp.e, imSize);
if ~isempty(s)
 
    % mean
    X = s([1 3]);
    Y = s([2 4]);
    set(SenFig.mean(Obs.lmk),...
        'xdata', X,...
        'ydata', Y,...
        'color', colors(2,:),...
        'vis',   'on');

    % ellipses
    if SenOpt.showEllip
        [X,Y] = cov2elli(Obs.par.endp(1).e, Obs.par.endp(1).E, 3, 10) ;
        set(SenFig.ellipse(Obs.lmk,1),...
            'xdata', X,...
            'ydata', Y,...
            'color', colors(3,:),...
            'vis',   'on');
        [X,Y] = cov2elli(Obs.par.endp(2).e, Obs.par.endp(2).E, 3, 10) ;
        set(SenFig.ellipse(Obs.lmk,2),...
            'xdata', X,...
            'ydata', Y,...
            'color', colors(3,:),...
            'vis',   'on');
    end
    
else % not visible
    set(SenFig.mean(Obs.lmk),'vis','off');
    set(SenFig.ellipse(Obs.lmk,:),'vis','off');
end


