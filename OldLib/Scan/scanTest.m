clear global
clear

% Image
global Image scanPix
if isempty(Image)
    Image = imread('images/image.005.s.png');
    Image = single(sum(Image,3)/3);
    Image1 = imread('images/image.005.s.png');
    Image1 = single(sum(Image1,3)/3);
end

% patch from Image1
% pPix  = [50;130]+fix(20*(rand(2,1)-.5)); % cycle patch pixel
pPix  = [250;130]+fix(20*(rand(2,1)-.5)); % box patch pixel
% pPix  = [48;137]; % overwrite AQUI
pSze  = 15; % patch size
pHSze = (pSze-1)/2;
patch = Image1(pPix(2)-pHSze:pPix(2)+pHSze,pPix(1)-pHSze:pPix(1)+pHSze);


% noisy patch
snr = 0.0;
pNoise = snr*256*randn(size(patch));
patch = patch + pNoise;

% search region is an ellipse
cxx = 25+14*rand;
cyy = 25+14*rand;
cxy = 25*(2*rand-1);
P = [cxx cxy;cxy cyy];
xm = pPix + fix(6*randn(2,1));
% xm = [45;136]; % overwrite AQUI
ns = 2;
region.type = 'ellipse';
region.data.u = xm;
region.data.U = P;
region.ns = ns;


% display image1
figure(1)
clf
colormap(gray(256));
subplot(1,2,1)
imHnd1 = image(Image1);
axis image
ax = get(imHnd1,'parent');
x1 = xm(1)-20;
x2 = xm(1)+20;
y1 = xm(2)-20;
y2 = xm(2)+20;
axis equal
title('Base Image')
axis([x1 x2 y1 y2])

% display image
subplot(1,2,2)
imHnd = image(Image);
axis image
ax1 = get(imHnd,'parent');
x1 = xm(1)-20;
x2 = xm(1)+20;
y1 = xm(2)-20;
y2 = xm(2)+20;
axis equal
title('Scan Image')
axis([x1 x2 y1 y2])

% display ellipse
[eX,eY] = cov2elli(xm,P,ns,16);
line('xdata',eX,'ydata',eY,'color','c');
line('xdata',xm(1),'ydata',xm(2),'color','c','marker','.');

% display true point
line('parent',ax,'xdata',pPix(1),'ydata',pPix(2),'color','r','marker','o');
x1 = pPix(1)-pHSze;
x2 = pPix(1)+pHSze;
y1 = pPix(2)-pHSze;
y2 = pPix(2)+pHSze;
line('parent',ax,'xdata',[x1 x1 x2 x2 x1],'ydata',[y1 y2 y2 y1 y1],'color','r')

% display scanned pixel
scanPix = line('xdata',[],'ydata',[],'color','g','marker','o');




% SCAN AREA 
th = .85;
mxSc = -1;
tic
[mxPix1,mxSc,scores] = areaScan(patch,th,xm,P,ns);
if mxSc~=-1
    [mxPix,mxSc,locScores] = localScan(patch,mxPix1,mxSc);
else
    mxPix = mxPix1;
    locScores = [];
end
scores = [scores locScores];
toc;
disp(['Score at found pixel is ' num2str(mxSc)])

if mxSc ~= -1
    % display found pixel
    line('xdata',mxPix(1),'ydata',mxPix(2),'color','b','marker','+');
    x1 = mxPix(1)-pHSze;
    x2 = mxPix(1)+pHSze;
    y1 = mxPix(2)-pHSze;
    y2 = mxPix(2)+pHSze;
    line('xdata',[x1 x1 x2 x2 x1],'ydata',[y1 y2 y2 y1 y1],'color','b')
    txt = text(mxPix(1)-6.7,mxPix(2)+pHSze+2,sprintf('Score: %0.2f',mxSc));
    set(txt,'color','b')

    Start_Real_Glob_Loc_Err = [xm,pPix,mxPix1,mxPix,mxPix-pPix]
    disp('---------------------------------')
else
    disp('Pixel not found inside region')
    disp('---------------------------------')
end

figure(2)
plot(scores)
axis([1 length(scores) 0 1]);
grid
