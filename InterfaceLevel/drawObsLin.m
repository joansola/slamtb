function drawObsLin(SenFig, Obs, SenFigOpt)

% DRAWOBSLIN  Draw an observed line on the pinHole sensor figure.
%   DRAWOBSLIN(SENFIG, OBS, COLORS, SENFIGOPT)  redraws a line
%   landmark on the pinHole sensor figure.
%
%   SENFIG    is the sensor figure's handles structure.
%   OBS       is the landmark-sensor observation structure.
%   SENFIGOPT is the sensor figure options, SENFIGOPT = FigOpt.sen.
%
%   See also DRAWOBSPNT, DRAWSENFIG, TRIMHMGLIN, COV2ELLI.

posOffset = 8;
colors = SenFigOpt.colors.plkLin; 

% the measurement:
if Obs.measured
    y = Obs.meas.y;
    set(SenFig.measure(Obs.lmk),...
        'xdata', [y(1);y(3)],...
        'ydata', [y(2);y(4)],...
        'color', colors.meas,...
        'vis',   'on');
    
    % the label
    c = (y(1:2)+y(3:4))*0.5;     % segment's center
    v = (y(1:2)-y(3:4));         % segment's vector
    n = normvec([-v(2);v(1)]);   % segment's normal vector
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
xlim = get(SenFig.axes,'xlim');
ylim = get(SenFig.axes,'ylim');
imSize = [xlim(2);ylim(2)];
s = trimHmgLin(Obs.exp.e, imSize);
% if ~isempty(s)
 
    % mean
    X = s([1 3]);
    Y = s([2 4]);
    set(SenFig.mean(Obs.lmk),...
        'xdata', X,...
        'ydata', Y,...
        'color', colors.mean,...
        'vis',   'on');

    % ellipses
    if SenFigOpt.showEllip
        [X,Y] = cov2elli(Obs.par.endp(1).e, Obs.par.endp(1).E, 3, 10) ;
        set(SenFig.ellipse(Obs.lmk,1),...
            'xdata', X,...
            'ydata', Y,...
            'color', colors.ellip,...
            'vis',   'on');
        [X,Y] = cov2elli(Obs.par.endp(2).e, Obs.par.endp(2).E, 3, 10) ;
        set(SenFig.ellipse(Obs.lmk,2),...
            'xdata', X,...
            'ydata', Y,...
            'color', colors.ellip,...
            'vis',   'on');
    end
    
% else % not visible - this piece of code only for robustness
%     set(SenFig.mean(Obs.lmk),'vis','off');
%     set(SenFig.ellipse(Obs.lmk,:),'vis','off');
% end


