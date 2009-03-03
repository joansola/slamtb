global Image

% renew patch selector: 
%    0: keep original
%    1: renew on score evaluation
%    2: renew always
renewPatch = 1; 

% video flag
video = false;

% Point selector (harris or God's finger)
harrisPix = true;

% God's finger pixel (from pixel list below)
GodsFingerPix = 6; % 0 for random selection

% Score colors and thresholds
yellowTh = .95; % very good match
orangeTh = .90; % poor match
redTh    = .85; % dangerous match
globTh   = orangeTh; % global to local scan switch threshold
locTh    = redTh; % local scan stop threshold
stdTh    = 0.04; % std deviation th. to renew patch

% Ptch size [hor;vert];
patchSize   = [1;1]*15;
patchSize2  = (patchSize-1)/2;
patchOrigin = (patchSize+1)/2;

% image files read
if ~exist('Img')
    if exist('/Volumes')==7
        dirname = '/Volumes/LLAPIS/Vslam/fis-slam/Experiments/Dala/test14/images/';
    elseif exist('/media')==7
        dirname = '/media/LLAPIS/Vslam/fis-slam/Experiments/Dala/test14/images/';
    else
        error('Directory path not found.')
    end
    filename1 = 'image.';
    filename2 = '.s.png';
    for f = 0:97
        filename = [dirname filename1 sprintf('%03d',f) filename2];
        Img{f+1} = sum(imread(filename),3)/3;
    end
end
Image = Img{1};

% Get Harris or define interest points
if harrisPix
    % Harris corner extractor
    [cim,r,c,s] = harris(Image,2,2000,2,0);
    cmin = 80;
    cmax = 512-80;
    rmin = 60;
    rmax = 200;
    rr = r((r>rmin)&(r<rmax)&(c>cmin)&(c<cmax));
    cc = c((r>rmin)&(r<rmax)&(c>cmin)&(c<cmax));
    Pix = [cc';rr'];
    
    % select one point
    pPix = Pix(:,ceil(size(Pix,2)*rand));
else
    % God's finger
    Pix = [];
    Pix = [Pix [145; 98]]; % 1  wall dot
    Pix = [Pix [266;227]]; % 2  floor dot
    Pix = [Pix [093; 63]]; % 3  building corner
    Pix = [Pix [159; 87]]; % 4  L door UL corner
    Pix = [Pix [379; 76]]; % 5  leafs
    Pix = [Pix [232; 83]]; % 6  trees over building
    Pix = [Pix [317; 87]]; % 7  hidden trees
    Pix = [Pix [190; 80]]; % 8  roof end
    Pix = [Pix [190; 85]]; % 9  roof end 2
    Pix = [Pix [190;100]]; % 10 0virtual point 1- buildings crossing
    Pix = [Pix [190;130]]; % 11 virtual point 2- buildings & floor crossing
    Pix = [Pix [200;130]]; % 12 R door LL corner
    Pix = [Pix [165;135]]; % 13 L door LL corner
    Pix = [Pix [172;136]]; % 14 L door bottom dot
    Pix = [Pix [ 40;130]]; % 15 bicycle
    Pix = [Pix [220;162]]; % 16 left box,  LL corner
    Pix = [Pix [245;162]]; % 17 left box,  LR corner
    Pix = [Pix [230;160]]; % 18 left box,  lower handle
    Pix = [Pix [335;162]]; % 19 right box, LL corner
    Pix = [Pix [360;162]]; % 20 right box, LR corner
    Pix = [Pix [335;144]]; % 21 right box, UL corner
    Pix = [Pix [360;144]]; % 22 right box, UR corner
    Pix = [Pix [350;160]]; % 23 right box, lower handle
    Pix = [Pix [345;140]]; % 24 right box, upper opening
    
    % select one point
    if GodsFingerPix
        pPix = Pix(:,GodsFingerPix);
    else
        pPix = Pix(:,ceil(size(Pix,2)*rand));
    end
end

% search region : ellipse
P      = [14 0;0 13]; % defined by an ellipse covariance
ns     = 4;           % and a number of sigma
% region = cov2par([0;0],P,ns); % this is a parallelogram

% search region : ray
Ray.n = 2;
Ray.w = [.5;.5];
Ray.u = [-3 3;0 0];
Ray.U(:,:,1) = P;
Ray.U(:,:,2) = P;
region = ray2par(Ray,ns); % this is a parallelogram

pix    = pPix; % Pixel to start scan
oldPix = pPix; % Last frame's pixel where scan started

% figure and axes initialization
fig1 = figure(1);
clf
if video
    mov = avifile('~/Desktop/scanTest.avi');
end
colormap(gray(256))
set(fig1,'doublebuffer','on')
% main frame - sensor image
ax1 = subplot(4,6,[1 2 3 4 7 8 9 10 13 14 15 16]);
% zoomed image
ax2 = subplot(4,6,[5 6 11 12]);
% original patch
ax3 = subplot(4,6,17);
% current patch
ax4 = subplot(4,6,18);
% scores plot
ax5 = subplot(4,6,[19 20 21 22]);
% current reference patch
ax6 = subplot(4,6,23);
% current patch at subpixellic position
ax7 = subplot(4,6,24);

% display full image
dispIm = image(Image,'parent',ax1);
axis(ax1,'image')
title(ax1,'Sensor image')

% pixel to track in image
dispPix = line('parent',ax1,'xdata',pPix(1),'ydata',pPix(2),'marker','+','color','r');

% region around current patch
zoomInSize = 3*patchSize;
zoomIm = pix2patch(round(pPix),zoomInSize);
dispSpatch = image(zoomIm.I,'parent',ax2);
axis(ax2,'image')
title(ax2,'Zoom')
Zpix = (zoomInSize+1)/2;

% ellipse
[ex,ey] = cov2elli(Zpix,P,ns,64);
dispElli = line('parent',ax2,'xdata',ex,'ydata',ey,...
    'linewidth',2,'color','g','linestyle','-');

% patch box
dispBox = line('parent',ax2,'color','b');

% original patch
origPatch = pix2patch(round(pPix),patchSize);
dispPatch0 = image(origPatch.I,'parent',ax3);
axis(ax3,'image')
title(ax3,'Original')

% current patch
currPatch = pix2patch(round(pPix),patchSize);
dispPatch = image(currPatch.I,'parent',ax4);
axis(ax4,'image')
title(ax4,'Current')

% current reference patch
refPatch = pix2patch(round(pPix),patchSize);
dispRef = image(refPatch.I,'parent',ax6);
axis(ax6,'image')
title(ax6,'Reference')

% current patch at sub pixellic position
subPatch = pix2patch(round(pPix),patchSize+2);
dispSub = image(subPatch.I,'parent',ax7);
axis(ax7,'image')
title(ax7,'Sub current')

% scores plot
scx = 1:97;
scy = -ones(1,97); % scores
scm = scy; % mean of last scores
scs = scy; % std dev. of last scores
dispSc  = line(scx,scy,'parent',ax5,'linewidth',2,'color','b');
dispScm = line(scx,scm,'parent',ax5,'linewidth',2,'color','m');
dispScs = line(scx,scs,'parent',ax5,'linewidth',2,'color','c');
title(ax5,'Scores')

% axes settings
set([ax1;ax2;ax3;ax4;ax5;ax6;ax7],...
    'fontsize',8)
set(ax5,...
    'ticklength',[0 .1],...
    'xtick',[],...
    'xticklabel',[],...
    'ytick',[.75+stdTh,redTh,orangeTh,yellowTh],...
    'yticklabel',[...
    ['STD DEV -> ' num2str(stdTh,'%.2f')];...
    ['    RED -> ' num2str(redTh,'%.2f')];...
    [' ORANGE -> ' num2str(orangeTh,'%.2f')];...
    [' YELLOW -> ' num2str(yellowTh,'%.2f')]],...
    'ygrid','on',...
    'xlim',[0 97],...
    'ylim',[.75 1]);
set([ax3;ax4;ax6],...
    'ticklength',[.02 .02],...
    'xtick',[3 8 13],...
    'xticklabel',[],...
    'ytick',[3 8 13],...
    'yticklabel',[]);
set(ax7,...
    'ticklength',[.02 .02],...
    'xlim',[1.5 16.5],...
    'ylim',[1.5 16.5],...
    'xtick',[4 9 14],...
    'xticklabel',[],...
    'ytick',[4 9 14],...
    'yticklabel',[]);

for f=1:97
    % new image
    Image = Img{f};
    set(dispIm,'cdata',Image);
    
    % display region around previous patch
    zoomIm = pix2patch(round(oldPix),zoomInSize);
    set(dispSpatch,'cdata',zoomIm.I);
    
    % Scan for patch!
    [currPix,sc,currPatch] = ...
        patchScan(refPatch,region,pix+[-1;1],globTh,locTh);
    scy(f) = sc;
    scHist = scy(max(1,f-4):f);
    scMean = mean(scHist);
    scm(f) = scMean;
    scStd  = std(scHist);
    scs(f) = 0.75+scStd;
    
    % set ellipse color
    if sc > yellowTh
        pColor = 'g'; % green
    elseif sc > orangeTh
        pColor = 'y'; % yellow
    elseif sc > redTh
        pColor = [1 .5 0]; % orange
    else
        pColor = 'r'; % red
    end
    
    % decide on patch renew and ellipse color
    if scMean > yellowTh
        eColor = 'g';
        pix   = currPix;
    elseif scMean > orangeTh
        eColor = 'y';
        pix   = currPix;
    elseif scMean > redTh && scStd < stdTh
        eColor = [1 .5 0]; % orange
        pix   = currPix;
        if renewPatch == 1
            % renew patch
            refPatch = currPatch;
        end
    else
        eColor = 'r'; % red
    end
    
    
    % inconditional patch renew
    if renewPatch == 2
        refPatch = currPatch;
    end

    % display found pix in image
    set(dispPix,'xdata',pix(1),'ydata',pix(2))
    
    % display found patch in region
    Bpix = Zpix+pix-oldPix;
    [bx,by] = box2sq(...
        Bpix(1)-patchSize2(1),...
        Bpix(1)+patchSize2(1),...
        Bpix(2)-patchSize2(2),...
        Bpix(2)+patchSize2(2));
    set(dispBox,'xdata',bx,'ydata',by)
    
    % display ellipse
    set(dispElli,'color',eColor);
    
    % display current patch
    set(dispPatch,'cdata',currPatch.I)
    
    % display scores plot
    set(dispSc,'ydata',scy)
    set(dispScm,'ydata',scm)
    set(dispScs,'ydata',scs)
    
    % display reference patch
    set(dispRef,'cdata',refPatch.I)
    
    % display current sub pixellic patch
    subPatch = pix2patch(round(currPix),patchSize+2);
    set(dispSub,'cdata',subPatch.I)
    subPix = currPix - round(currPix);
    subXlim = subPix(1) + [1.5 patchSize(1)+1.5];
    subYlim = subPix(2) + [1.5 patchSize(2)+1.5];
    set(ax7,'xlim',subXlim,'ylim',subYlim)
    drawnow
    
    oldPix = pix;
    
    if video
        mov = addframe(mov,getframe(fig1));
    end

end

if video
    mov = close(mov);
end
