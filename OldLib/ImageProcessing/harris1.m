% HARRIS  Harris corner detector
%
% Usage:  [pix, s] = harris(im, sigma, thresh, method)
%
% Arguments:
%            im     - image to be processed.
%            sigma  - standard deviation of smoothing Gaussian. Typical
%                     values to use might be 1-3.
%            thres  - threshold score to validate corner
%            method - 'harris' 'noble' 'shi'
%
% Returns:
%            r      - row coordinate of corner point.
%            c      - column coordinate of corner point.
%            s      - strength of corner point
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

function [pix, s] = harris1(im, sigma, thresh, method)

persistent g; % gaussian filter

% error(nargchk(2,4,nargin));

dx = [-1 0 1; -2 0 2; -1 0 1]; % Derivative masks
dy = dx';

Ix = conv2(im, dx, 'same');    % Image derivatives
Iy = conv2(im, dy, 'same');

% Generate Gaussian filter of size 2*ns*sigma (+/- ns*sigma) and of
% minimum size 1x1.
if isempty(g)
%     ns = 2; % here only +/- 2sigma
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

[s,r] = max(cim);
[s,c] = max(s);
if s >= thresh
    pix   = [r(c);c];
else
    pix = [];
end
