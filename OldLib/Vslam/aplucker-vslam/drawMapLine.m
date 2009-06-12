function dispMapLine = drawMapLine(dispMapLine,Line,ns,drawEndPoints)

% DRAWMAPLINE  Draw map line
%   H = DRAWMAPLINE(H,L)  updates the line graphic handle H so that the
%   line L is redrawn at the location specified in the global SLAM map Map.

global Map

coordNames = {'xdata','ydata','zdata'};

if Line.used  % draw lines
    lr    = Line.r;
    aline  = Map.X(lr);
    [line,L_al] = unanchorPlucker(aline);
    Pline = L_al*Map.P(lr(1:end),lr(1:end))*L_al';
    s     = Line.s;

    % endpoints
    [e1,e2,E1_l,E2_l] = ls2ee(line,s(1),s(2));
    coordValues       = {[e1(1) e2(1)],[e1(2) e2(2)],[e1(3) e2(3)]};
    set(dispMapLine.seg ,coordNames,coordValues);

    if drawEndPoints
        % ellipses
        E1          = E1_l*Pline*E1_l';
        [X,Y,Z]     = cov3elli(e1,E1,ns,16);
        coordValues = {X,Y,Z};
        set(dispMapLine.cov1,coordNames,coordValues);

        E2          = E2_l*Pline*E2_l';
        [X,Y,Z]     = cov3elli(e2,E2,ns,16);
        coordValues = {X,Y,Z};
        set(dispMapLine.cov2,coordNames,coordValues);
    end
    
    % label text
    txtPos = e1;
    set(dispMapLine.txt ,'string',Line.id,'pos',txtPos);

else % draw nothing
    coordValues = {[],[],[]};
    set(dispMapLine.seg ,coordNames,coordValues);
    set(dispMapLine.cov1,coordNames,coordValues);
    set(dispMapLine.cov2,coordNames,coordValues);
    set(dispMapLine.txt ,'string','','pos',[0 0 0]);
end
