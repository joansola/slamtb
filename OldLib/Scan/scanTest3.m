% clear
% clear global
format compact

harrisPix = false;

global scanPix Image Image1

if isempty(Image)
    Image = imread('/media/LLAPIS/Vslam/fis-slam/Experiments/Dala/test14/images/image.000.s.png');
    Image = single(sum(Image,3)/3);
    Image1 = imread('/media/LLAPIS/Vslam/fis-slam/Experiments/Dala/test14/images/image.001.s.png');
    Image1 = single(sum(Image1,3)/3);
end

% original pixel to track
if harrisPix
    % Harris corner extractor
    [cim,r,c,s] = harris(Image,2,2000,2,0);
    s = size(cim);
    cmin = 80;
    cmax = 512-80;
    rmin = 60;
    rmax = 200;
    rr = r((r>rmin)&(r<rmax)&(c>cmin)&(c<cmax));
    cc = c((r>rmin)&(r<rmax)&(c>cmin)&(c<cmax));
    Pix = [cc';rr'];
else
    % God's finger
    Pix = [];
    Pix = [Pix [145; 98]]; % wall dot
    Pix = [Pix [266;227]]; % floor dot
    Pix = [Pix [093; 63]]; % building corner
    Pix = [Pix [159; 87]]; % L door UL corner
    Pix = [Pix [379; 76]]; % leafs
    Pix = [Pix [232; 83]]; % trees over building
    Pix = [Pix [317; 87]]; % hidden trees
    Pix = [Pix [190; 80]]; % roof end
    Pix = [Pix [190; 90]]; % roof end 2
    Pix = [Pix [190;100]]; % virtual point 1- buildings crossing
    Pix = [Pix [190;130]]; % virtual point 2- buildings & floor crossing
    Pix = [Pix [200;130]]; % R door LL corner
    Pix = [Pix [165;135]]; % L door LL corner
    Pix = [Pix [172;136]]; % L door bottom dot
    Pix = [Pix [ 40;130]]; % bicycle
    Pix = [Pix [220;162]]; % left box,  LL corner
    Pix = [Pix [245;162]]; % left box,  LR corner
    Pix = [Pix [230;160]]; % left box,  lower handle
    Pix = [Pix [335;162]]; % right box, LL corner
    Pix = [Pix [360;162]]; % right box, LR corner
    Pix = [Pix [335;142]]; % right box, UL corner
    Pix = [Pix [360;142]]; % right box, UR corner
    Pix = [Pix [350;160]]; % right box, lower handle
    Pix = [Pix [345;140]]; % right box, upper opening
end
pPix = Pix(:,ceil(size(Pix,2)*rand));
% pPix = Pix(:,6); % God's finger
pPix

% patch
pSze  = 15; % patch size
pHSze = (pSze-1)/2;
patch = pix2patch(pPix,pSze);
% patch = Image1(pPix(2)-pHSze:pPix(2)+pHSze,pPix(1)-pHSze:pPix(1)+pHSze);

% sub-image
ax2=subplot(2,2,2)
colormap(gray(256))
image(Image1)
axis(ax2,'image')
set(gca,...
    'xlim',[pPix(1)-21 pPix(1)+21],...
    'ylim',[pPix(2)-21 pPix(2)+21])


% ellipse
pix0 = pPix + round(5*(2*rand(2,1)-1));
% pix0 = [162;135]; % God's finger
cxx = 6+5*rand;
cyy = 6+5*rand;
cxy = 6*(2*rand-1);
P = [cxx cxy;cxy cyy];
% P = [5.47 3.7;3.7 7.25]; % God's finger
ns = 3;

% search region : ray
Ray.n = 2;
Ray.w = [.5 .5];
Ray.u = [-3 3;0 0];
Ray.U(:,:,1) = P;
Ray.U(:,:,2) = P;

region = ray2par(Ray,ns); % this is a parallelogram
% region = cov2par(P,ns);
pixDist = 2;

[ex,ey] = cov2elli(pix0,P,ns,64);
subplot(2,2,2)
line(ex,ey)
% axis equal
grid
scanPix = line(...
    'xdata',[],...
    'ydata',[],...
    'marker','o',...
    'color','r',...
    'linestyle','none');
set(gca,...
    'ydir','reverse',...
    'xlimmode','manual',...
    'ylimmode','manual')

% dir = [0;1];
th = .85;

subplot(2,2,4)
tic
% global scan at 2 pix spacing, trigged at threshold th.
[mxPix,mxSc,scIm,scIm0,dir]=globalScan3(patch,region,pix0,th,2);
tocG = toc;

% local scan at 2 pix spacing
% [mxPix,mxSc,scIm,scIm0,dir] = localScan3(patch,mxPix,scIm,scIm0,dir,2);
tocL2 = toc;

% local scan at 1 pix spacing
[mxPix,mxSc,scIm] = localScan3(patch,mxPix,scIm,scIm0,dir,1);
tocL1 = toc;

% sub-pixel resolution
subPix = mxPix+maxParab2(scIm(2,2),scIm(2,1),scIm(2,3),scIm(1,2),scIm(3,2));
tocS = toc;

image((1+scIm)*127)
colormap(gray(256))
axis image

set(scanPix,'xdata',mxPix(1),'ydata',mxPix(2));

fprintf('\nProcessing times:\n')
fprintf('Global 2 pix: %5.1f - %5.1f ms\n',1000*tocG,1000*tocG);
fprintf('Local  2 pix: %5.1f - %5.1f ms\n',1000*(tocL2-tocG),1000*tocL2);
fprintf('Local  1 pix: %5.1f - %5.1f ms\n',1000*(tocL1-tocL2),1000*tocL1);
fprintf('Sub pixel   : %5.1f - %5.1f ms\n',1000*(tocS-tocL1),1000*tocS);

disp(' ')
% disp('Sub-pixel resolution...')
subPix
mxPix
mxSc

% searched patch
subplot(2,2,1)
image(patch.I)
axis image
colormap(gray(256))

% found patch
fPatch = pix2patch(mxPix,pSze);
subplot(2,2,3)
image(fPatch.I)
axis image

disp('----------------------------------------------------')
