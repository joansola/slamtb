function [mxPix,mxSc,scIm] = regionScan(patch,region,pix0,pixDist)

global scanPix;

if nargin<4
    pixDist = 2;
end

x0 = region.x0;
y0 = region.y0;
Xm = region.Xm;
XM = region.XM;
Ym = region.Ym;
YM = region.YM;
mx = region.mx;
my = region.my;

% bounding box in integer pixels
[scIm,scIm0] = par2scIm(Xm,XM,Ym,YM,pixDist);

if (XM-Xm) > (YM-Ym) % rather horizontal region: N-shaped scan
    lowDir  = [0;1]; % lower level scan direction
    highDir = [1;0]; % higher level scan direction
    m       = my;    % bounding slope low = low0 + m*high
    low0    = y0;
    highm   = Xm;
    highM   = XM;
    lowm    = Ym;
    lowM    = YM;
else % rather vertical region: Z-shaped scan
    lowDir  = [1;0];
    highDir = [0;1];
    m       = mx;
    low0    = x0;
    highm   = Ym;
    highM   = YM;
    lowm    = Xm;
    lowM    = XM;
end

high0  = 0;

high   = high0;
highSide   = true;
highOffset = 0;

mxSc   = -1;
mxPix  = pix0;

out    = 0; % end of scan when out == 2

% coarse scan at pixDist pixel spacing
hm = real2int(highm,pixDist); % integer bounds
hM = real2int(highM,pixDist);
while (high >= hm) && (high <= hM)
% while out < 2

    lowmin = -low0 + m*high; % real
    lowMax =  low0 + m*high;

    lowmin = max(lowm,lowmin);
    lowMax = min(lowM,lowMax);
    
    lowmin = real2int(lowmin,pixDist);
    lowMax = real2int(lowMax,pixDist);
    
    %     if ((highOffset > 0) && inM) || ((highOffset < 0) && (inm))
    for low = lowmin:pixDist:lowMax
        % lower level scan
        pixOffset = low*lowDir+high*highDir;
        pix = pix0 + pixOffset; % pixel to look at
        sc = patchCorr(pix,patch,'zncc');

        scInd = scIm0+pixOffset;
        scIm(scInd(2),scInd(1)) = sc;
        
        if sc > mxSc
            mxSc        = sc;
            mxPixOffset = pixOffset;
        end

        set(scanPix,'xdata',pix(1),'ydata',pix(2));
        image((scIm+1)*127)
        axis image
        drawnow
        pause(.05)

    end

    if highSide % change of high side and augment
        highOffset = -highOffset + pixDist;
        high = high0 + highOffset;
%         if high > highM % out of region
%             inM = false;
%             out = out + 1;
%         end

    else      % only change high side
        highOffset = -highOffset;
        high = high0 + highOffset;
%         if high < highm % out of region
%             inm = false;
%             out = out+1;
%         end
    end
    
    highSide = ~highSide;

end

image((scIm+1)*127)
axis image
drawnow

% output
mxPix = pix0 + mxPixOffset;
xRng = scIm0(1) + mxPixOffset(1) + [-2:2];
yRng = scIm0(2) + mxPixOffset(2) + [-2:2];
scIm = scIm(yRng,xRng);

