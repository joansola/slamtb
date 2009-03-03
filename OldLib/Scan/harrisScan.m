function [subPix,mxSc,ptchOut] = harrisScan(ptchIn,region,m,locTh)

global Image

u0 = region.x0;

rect = [u0(1)+[region.Xm region.XM] u0(2)+[region.Ym region.YM]];
recti = round(rect); % integer rectangle
rectr = rect-recti;  % residual
pix0 = (recti([1 3])' - [m;m] - [1;1]);

% cut image
im = subImg(recti,m);

% % Draw region in figure 4
% figure(4)
% subplot(1,2,1)
% image(im)
% colormap(gray(256));
% axis image
% subplot(1,2,2)
% image(ptchIn.I)
% axis image
% drawnow


% get Harris points
% [pix,hsc] = Nharris(im,10,m,2,1000,2);
[pix,hsc] = Nharris(im,10,m,2,500,2); % AQUI
n = length(hsc);

if n % at least one point found
    pix = pix + repmat(pix0,1,n);

    % Compute correlations for all Harris points
    scores = -ones(1,n);
    for i = 1:n
        scores(i) = patchCorr(pix(:,i),ptchIn,'zncc');
    end

    % max score and pixel
    [scMax,idx] = max(scores);
    pix = pix(:,idx);

        % local scan
        scIm = -ones(9);
        scIm0 = [5;5];
        scIm(scIm0(1),scIm0(2)) = scores(idx);
        [mxPix,mxSc,scIm] = localScan3(ptchIn,pix,scIm,scIm0,[1;0],1,locTh);
    
    
        % sub-pixel resolution
        subPix = mxPix + maxParab2(...
            scIm(2,2),...
            scIm(2,1),...
            scIm(2,3),...
            scIm(1,2),...
            scIm(3,2));

%         subPix = mxPix;

%     subPix = pix;
%     mxSc = scores(idx);

    % full real precision pixel
    subPix = subPix + ptchIn.bias;

else % No harris point found inside region
    subPix = u0;
    mxSc = 0;
end




% new patch if required at output
if nargout == 3
    % Re-centered max pix (in case subPix + patchBias residual
    % accumulates to more than half a pixel, resulting in a new
    % subPix too far from the integer pixel)
    %     mxPix = round(subPix);

    % new patch
    hSze  = size(ptchIn.I,2);
    vSze  = size(ptchIn.I,1);
    ptchOut = pix2patch(subPix,hSze,vSze);
    %     ptchOut = ptchIn;

end

