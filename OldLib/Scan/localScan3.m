function [mxPix,mxSc,scIm,scIm0,dir] = localScan3(imId,ptch,pix0,scIm,scIm0,dir0,pixDist,th)
%
% LOCALSCAN3  Locally scan for a patch in an image
%   [MXPIX,MXSC] = LOCALSCAN3(IMID,PATCH,PIX,SCIM,SCIM0,DIR,PXDST,TH)
%   scans the global image Image{IMID} for a patch PATCH starting
%   at pixel PIX with direction DIR and pixel spacing PXDST. Scan
%   is terminated when all cardinal neighbours of the pixel with
%   maximum score have lower scores.
%   Scan is also terminated when an out-of-region is detected
%   with a maximum score lower than threshold TH. Default
%   threshold is TH = 0.7.
%   The pixel with maximum score is returned in MXPIX and its
%   score in MXSC.
%   
%
%   [MXPIX,MXSC,SCIM,SCIM0] = LOCALSCAN3(...) returns the
%   incomplete score image SCIM, with the index SCIM0
%   corresponding to pixel PIX, that is updated as the scan
%   progresses.
%
%   [MXPIX,MXSC,SCIM,SCIM0,DIR] = LOCALSCAN3(...) returns also
%   the direction at which the scan was being performed when
%   termination condition was met.
%
%   See also PATCHSCAN, GLOBALSCAN3
%

%   (c) 2005 Joan Sola @ LAAS-CNRS
%   Tolosa de Llenguadoc, Occitania.

global scanPix Image
persistent steer

if isempty(steer) % define steering matrices only once:
    steer(:,:,1) = eye(2);      % first look straight
    steer(:,:,2) = [0 1;-1 0];  % then right
    steer(:,:,3) = [0 -1;1 0];  % then left
    steer(:,:,4) = [-1 0;0 -1]; % then back
end

if nargin < 8
    th = .07;
end

pix1 = pix0; % pivot pixel
dir1 = dir0; % scan direction
sc1  = scIm(scIm0(2),scIm0(1)); % pivot score
isPivot = false;
isInside = true;

% % size of image
% Ix = size(Image,2); % horizontal pixels (columns)
% Iy = size(image,1); % vertical pixels (rows)

% size of scan area
Sx = size(scIm,2);
Sy = size(scIm,1);
S = [Sx;Sy]; % size in x-y format (normally is in c-r which is the opposite)

mxPix = pix0;
mxSc  = sc1;
iMax = 4; % start looking at all cardinal directions

while ~isPivot && isInside

    for i = 1:iMax % look at all directions
        dir = steer(:,:,i)*dir1;  % scan direction
        pix = pix1 + dir*pixDist; % checked pixel
        scImIdx  = (pix-pix0) + scIm0; % checked pixel index in scores image

        isInside = all(scImIdx >= 1) && all(scImIdx <= S);
        isGood   = mxSc > th;
        
        if  ~isInside && ~isGood % Pixel is out and weak
%             warning('Out of scan area')
            break % terminate scan
            
        else
            if ~isInside && isGood % Pixel is out but good
                % sc image at pivot
                scImIdx1 = (pix1-pix0)+scIm0; % pivot index
                % cut new scores image
                [scIm,scIm0] = cutIm(scIm,scImIdx1,S,-1);
                pix0 = pix1; % pivot is center of region
                scImIdx = (pix-pix0) + scIm0; % pixel index
                isInside = true;
            end
            
            % now pixel is in 
            if scIm(scImIdx(2),scImIdx(1)) == -1 % score not present
                % compute it
                scIm(scImIdx(2),scImIdx(1)) = patchCorr(imId,pix,ptch,'zncc');
            end

            sc = scIm(scImIdx(2),scImIdx(1));

            if sc > sc1 % checked pixel is better than pivot
                pix1  = pix; % checked pix becomes new pivot
                dir1  = dir; % current dir becomes new dir
                sc1   = sc;  % score is pivot score
                mxPix = pix; % score is max score
                mxSc  = sc;  % pixel is max pixel
                break        % stop looking at other neighbours

            elseif i==iMax % all neighbours are checked
                isPivot = true; % best is pivot

            end
        end
        % display
        
%         figure(9);imshow((1+scIm)/2);set(gca,'position',[0 0 1 1])
%         scIm;
%         set(scanPix,'xdata',pix(1),'ydata',pix(2));
%         image((1+scIm)*127)
%         axis image
%         drawnow
%         pause(.2)
    end
    iMax = 3; % don't look backwards from the second pivot on

    % display
%     set(scanPix,'xdata',pix(1),'ydata',pix(2));
%     image((1+scIm)*127)
%     axis image
%     drawnow
%     pause(.2)
end

offPix = mxPix - pix0;     % max pixel offset from origin
scImIdx  = scIm0 + offPix; % origin of new scores image
[scIm,scIm0] = cutIm(scIm,scImIdx,2*pixDist+1,-1); % new scores image

