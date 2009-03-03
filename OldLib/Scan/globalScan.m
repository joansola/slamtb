function [pix,sc,dir] = globalScan(patch,xm,region,threshold)

global scanPix

dir = [2;0];
pix = xm;
pix = xm;
sc = 0;
dist = 0;
maxDist = 0;
chDist  = true;
corner  = 0;
oneTurn = false;
onePix  = false;

while (~oneTurn)
%     set(scanPix,'xdata',pix(1),'ydata',pix(2));
%     drawnow
    pause(.1)
    if isInRegion(pix,region)
        sc = patchCorr(pix,patch,'zncc');
        if sc > threshold
            break
        end
        corner = 0;           % reset corner counter
    end
    dist = dist+1;            % distance run
    if dist >= maxDist        % if in corner:
        corner = corner + 1;  %  one more corner
        if corner > 4         %  if more than four
            oneTurn = true;   %   we did one whole turn
            sc = -1;          % mark for "patch not found"
            break
        end
        dir = [0 -1;1 0]*dir; %  turn left
        dist = 0;             %  reset distance
        if chDist             %  if second corner
            maxDist = maxDist + 1; % increment max distance
        end
        chDist = ~chDist;     %  one every second corner
    end
    pix = pix+dir;            % next pixel...
end



