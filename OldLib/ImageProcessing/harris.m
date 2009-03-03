% HARRIS  Harris corner detector
%
% Usage:  [r, c, s, cim] = harris(im, sigma, thresh, radius, method, disp)
%
% Arguments:
%            im     - image to be processed.
%            sigma  - standard deviation of smoothing Gaussian. Typical
%                     values to use might be 1-3.
%            thresh - threshold (optional). Try a value ~1000.
%            radius - radius of region considered in non-maximal
%                     suppression (optional). Typical values to use might
%                     be 1-3.
%            method - 'harris' 'noble' 'shi'
%            disp   - optional flag (0 or 1) indicating whether you want
%                     to display corners overlayed on the original
%                     image. This can be useful for parameter tuning.
%
% Returns:
%            cim    - binary image marking corners.
%            r      - row coordinates of corner points.
%            c      - column coordinates of corner points.
%            s      - strengths of corner points
%
% If thresh and radius are omitted from the argument list 'cim' is returned
% as a raw corner strength image and r, c and s are returned empty.

% References:
% C.G. Harris and M.J. Stephens. "A combined corner and edge detector",
% Proceedings Fourth Alvey Vision Conference, Manchester.
% pp 147-151, 1988.
%
% Alison Noble, "Descriptions of Image Surfaces", PhD thesis, Department
% of Engineering Science, Oxford University 1989, p45.
%
%
% Author:
% Peter Kovesi
% Department of Computer Science & Software Engineering
% The University of Western Australia
% pk @ csse uwa edu au
% http://www. csse.uwa.edu.au/~pk
%
% March 2002    - original version
% December 2002 - updated comments
% May 2006      - some variations by Joan Sola

function [r, c, s, cim] = harris(im, sigma, thresh, radius, method, disp)

persistent g; % gaussian filter

error(nargchk(2,6,nargin));

dx = [-1 0 1; -2 0 2; -1 0 1]; % Derivative masks
dy = dx';

Ix = conv2(im, dx, 'same');    % Image derivatives
Iy = conv2(im, dy, 'same');

% Generate Gaussian filter of size 2*ns*sigma (+/- ns*sigma) and of
% minimum size 1x1.
if isempty(g)
    ns = 2; % here only +/- 2sigma
%     g = fspecial('gaussian',max(1,fix(ns*sigma)), sigma);
    g = zeros(sigma+2);
    g(2:sigma+1,2:sigma+1) = ones(sigma)/sigma^2;
end

Ix2 = conv2(Ix.^2, g, 'same'); % Smoothed squared image derivatives
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g, 'same');

% Compute the Harris corner measure. Note that there are three
% measures that can be calculated.  I prefer the first one below
% as given by Nobel in her thesis (reference above).  The second
% one corresponds directly to the smallest eigenvalue. The third
% one requires setting a parameter, it is commonly suggested that
% k=0.04 - I find this a bit arbitrary and unsatisfactory. 
%
if strncmp(method,'noble',3)
   
   cim = (Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps); % Noble's measure.
   
elseif strncmp(method,'shi',3)
   
   cim = (Ix2+Iy2-sqrt((Ix2-Iy2).^2+4*Ixy.^2));  % Smallest eigenvalue.
   
else
   k = 0.04;
   cim = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2; % Original Harris measure.
   
end

% Eliminate close-to-the-border scores
% mrg = 

if nargin > 2 & ~isempty(thresh)  % We should perform nonmaximal suppression and thresholding

    % Extract local maxima by performing a grey scale morphological
    % dilation and then finding points in the corner strength image that
    % match the dilated image and are also greater than the threshold.
    sze   = 2*radius+1;                    % Size of mask.
    mx    = ordfilt2(cim,sze^2,ones(sze)); % Grey-scale dilate.
    cimb  = (cim==mx)&(cim>thresh);        % Find maxima.

    [r,c] = find(cimb);      % Find row,col coords.
    s     = cim(cimb);       % Strength at cim(r,c)

    if nargin==6 && disp      % overlay corners on original image
        figure(99)
        image(im);hold on
        colormap(gray(256));
        plot(c,r,'r+'), title('Detected Corners');
        axis image
    end

else  % leave cim as a corner strength image and make r and c empty.
    % return the absolute maximum as unique corner
    [cr,r]  = max(cim);
    [crc,c] = max(cr);
    r       = r(c);
    s       = crc;
%     r = []; c = []; s = [];
end
