clear
clear global
format compact

global scanPix Image Image1

if isempty(Image)
    Image = imread('/media/LLAPIS/Vslam/fis-slam/Experiments/Dala/test14/images/image.005.s.png');
    Image = single(sum(Image,3)/3);
    Image1 = imread('/media/LLAPIS/Vslam/fis-slam/Experiments/Dala/test14/images/image.007.s.png');
    Image1 = single(sum(Image1,3)/3);
end

% % harris
% [cim,r,c,s] = harris(Image1,2,1000,2,1);
% s = size(cim);
% m = 30;
% i = find((r>m)&(r<s(1)-m));
% r = r(i);
% c = c(i);
% i = find((c>m)&(c<s(2)-m));
% r = r(i);
% c = c(i);
% i = round(rand*length(r));
% r = r(i);
% c = c(i);
% disp('Corner point')
% pPix = [c;r]

% God's finger
pPix = [100;40] + round([50*rand;5*rand]);

% patch
pSze  = 11; % patch size
pHSze = (pSze-1)/2;
patch = Image1(pPix(2)-pHSze:pPix(2)+pHSze,pPix(1)-pHSze:pPix(1)+pHSze);

subplot(2,2,1)
image(patch)
axis image
colormap(gray(256))

% ellipse
pix0 = pPix + [1;1];
cxx = 5+5*rand;
cyy = 5+5*rand;
cxy = 5*(2*rand-1);
P = [cxx cxy;cxy cyy];
% P = [10 5;5 7];
ns = 3;
region = cov2par(P,ns);
pixDist = 2;

[ex,ey] = cov2elli(pix0,P,ns,64);
subplot(2,2,2)
plot(ex,ey)
axis equal
grid
scanPix = line(...
    'xdata',[],...
    'ydata',[],...
    'marker','o',...
    'color','r',...
    'linestyle','none');
set(gca,'ydir','reverse')

tic
%  coarse scan at pixDist pixel spacing
subplot(2,2,3)
axis image
disp(' ')
disp('Coarse scan at pixDist pixel spacing...')
[mxPix,mxSc,scIm]=regionScan2(patch,region,pix0,pixDist)
% [mxPix,mxSc,scIm]=regionScan2(patch,region,pix0,1)

subplot(2,2,4)
scIm(scIm<-1)=-1;
image((1+scIm)*127)
axis image
colormap(gray(256))

% local scan at 1 pixel spacing
subplot(2,2,4)
disp(' ')
disp('Fine scan at 1 pixel spacing...')
[mxPix,mxSc,scIm] = localScan2(patch,mxPix,mxSc,scIm)
subplot(2,2,4)
image((1+scIm)*127)
axis image
% image((scIm)*255)

% found patch
fPatch = pix2patch(mxPix,pSze);
subplot(2,2,2)
image(fPatch)
axis image

% sub-pixel resolution
disp(' ')
disp('Sub-pixel resolution...')
subPix = mxPix+maxParab2(scIm(2,2),scIm(2,1),scIm(2,3),scIm(1,2),scIm(3,2))

toc


disp('----------------------------------------------------')
