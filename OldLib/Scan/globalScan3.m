function [mxPix,mxSc,scIm,scIm0,dir] =...
    globalScan3(imId,ptch,region,pix0,th,pixDist)

%
% GLOBALSCAN3  Globally scan for a patch in an image region 
%   [MXPIX,MXSC] = GLOBALSCAN3(IMID,PATCH,REG,PIX0,TH,PXDST)
%   scans the region REG in the global image Image{IMID} for a
%   pixel that correlates PATCH with the corresponding patch in
%   the image. The scan  terminates when the correlation score is
%   greater than threshold TH. The scan is performed at PXDST
%   pixel spacing.
%   The pixel with maximum score is returned in MXPIX and its
%   score in MXSC.
%
%   [MXPIX,MXSC,SCIM,SCIM0] = GLOBALSCAN3(...) also return an 
%   image SCIM of all computed scores centered at SCIM0. Non
%   computed scores are set to -1.
%
%   [MXPIX,MXSC,SCIM,SCIM0,DIR] = GLOBALSCAN3(...) gives the 
%   direction DIR at which the scan was terminated. This is 
%   useful to better start a later local or finer scan.
%
%   See also PATCHSCAN, LOCALSCAN3, MAXPARAB2, and COV2PAR for 
%   details on the region parameters.

%   (c) 2005 Joan Sola @ LAAS-CNRS
%   Tolosa de Llenguadoc, Occitania.


if nargin<6
    pixDist = 2;
end

xa = region.xa;
ya = region.ya;
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
    m       = mx;    % bounding slope low = low0 + m*high
    low0    = ya;
    highm   = Xm;
    highM   = XM;
    lowm    = Ym;
    lowM    = YM;
else % rather vertical region: Z-shaped scan
    lowDir  = [1;0];
    highDir = [0;1];
    m       = my;
    low0    = xa;
    highm   = Ym;
    highM   = YM;
    lowm    = Xm;
    lowM    = XM;
end

hm = bround(highm,pixDist); % integer bounds
hM = bround(highM,pixDist);

if hm*hM < 0 % starting high point
    high0  = 0;
else
    high0 = round((hM+hm)/2);
end

high   = high0;
highSide   = true;
highOffset = 0;

mxSc   = -1;
mxPixOffset = [0;0];

% coarse scan at pixDist pixel spacing
while (high >= hm) && (high <= hM)

    lowmin = -low0 + m*high; % real
    lowMax =  low0 + m*high;

    lowmin = max(lowm,lowmin);
    lowMax = min(lowM,lowMax);
    
    lowmin = bround(lowmin,pixDist);
    lowMax = bround(lowMax,pixDist);
    
    for low = lowmin:pixDist:lowMax
        % lower level scan
        pixOffset = low*lowDir + high*highDir;
        pix       = pix0 + pixOffset; % pixel to look at
        sc        = patchCorr(imId,pix,ptch,'zncc');
        
%         if sc>.9
%             sc
%         end

        scInd = scIm0 + pixOffset;
        if (scInd(2)>0) && (scInd(1)>0)
            scIm(scInd(2),scInd(1)) = sc;
        else
            disp('paused in globalScan3.m - press enter to continue.')
            pause
        end
        
        
        if sc > mxSc
            mxSc        = sc;
            mxPixOffset = pixOffset;
            if mxSc > th
                break
            end
        end
        
    end % low scan loop
    
    
    if mxSc > th
        break
    end

%     figure(9);imshow((1+scIm)/2);set(gca,'position',[0 0 1 1])

    % Check region limits. high1 is next high value before checking
    high1 = high0 - highOffset + highSide*sign(-highOffset+0.5)*pixDist;

    if high1 < hm     % lower limit reached
        highOffset = highOffset + pixDist;
    elseif high1 > hM % higher limit reached
        highOffset = highOffset - pixDist;
    else % no limit yet
        highOffset = -highOffset + highSide*pixDist;
        highSide = ~highSide;
    end

    high = high0 + highOffset;
    
    
end


% output
mxPix = pix0 + mxPixOffset;
dir   = lowDir;
scIm0 = scIm0 + mxPixOffset;
[scIm,scIm0] = cutIm(scIm,scIm0,4*pixDist+1,-1);

