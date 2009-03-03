function [pixel,sc,scores] = areaScan(patch,th,xm,P,ns)

% AREASCAN  Correlation score inside an elliptic area
%   [PIX,SC] = AREASCAN(PATCH,TH,XM,P,NS) gives the
%   correlation scores SC associated at each pixel PIX
%   inside the elliptic region corresponding to the 
%   NS-sigma bound of the 2D-Gaussian defined by
%   the mean XM and the covariance P. 
%   Correlation is performed between the patch PATCH and the 
%   equally sized patch of the global image Image centered
%   at each scanned pixel.
%
%   If no match is found the returned score is marked SC = -1
%
%   See also LINESCAN, PATCHCORR

global scanPix

% Initialize output variables
sc     = -1; % no good maximum found
pixel = zeros(2,0);

% Scan parameters
pix     = xm; % starting pixel is the center of the ellipse
hOffset = 0; % horizontal offset, starting at ellipse mean
vOffset = 0; % vertical offset, starting at ellipse mean
vDir    = 1; % vertical direction, starting down
hDir    = 1; % horizontal direction, starting right
scanStep = 2; % inter-pixel distance for global scan 
scores = []; % scores vector
kMax = -1;
scRight = 0;

% Perform scan
while isInElli(pix,xm,P,ns)
%     set(scanPix,'xdata',pix(1),'ydata',pix(2));
    [lScore,n,scMax,kMax,pixMax] = lineScan(patch,pix,hDir*scanStep,th,xm,P,ns); % line scan scores
    scores = [scores lScore];
    switch kMax
        case -1 % no max found in line
            if scRight 
                sc = scRight;
                pixel = pixRight;
                break
            end
        case 0 % max at the beginning of line
            if hDir == 1 % store right pixel
                scRight = scMax;
                pixRight = pixMax;
            else % choose left or right pixel and finish
                if scRight > scMax % choose right
                    sc = scRight;
                    pixel = pixRight;
                    break
                else % choose left
                    sc = scMax;
                    pixel = pixMax;
                    break
                end
            end
        otherwise % max within line => terminate
            pixel = pixMax;
            sc = scMax;
            break
    end
    
    
    hDir = -hDir; % change horizontal direction
    if hDir == 1 % Both h-directions done, the last was _left_
        hLeft   = n; % number of pixels to the left
        vOffset = -vOffset;
        if vOffset > 0 % Both v-directions done, the last was _down_
            vOffset = vOffset + scanStep;
            hOffset = hOffset - hRight + hLeft;
        elseif vOffset == 0
            vOffset = scanStep;
        end
        pix = xm + [sign(vOffset)*hOffset;vOffset]; % starting pix-next line
    else % _right_ direction scan done. Prepare for _left_.
        hRight = n-1; % number of pixels to the right
        pix(1) = xm(1) + sign(vOffset)*hOffset - scanStep; % starting pix-reverse direction
    end
end
