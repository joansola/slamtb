function [point,sc] = harris_strongest(im,sigma,mrg,edgerej)
% HARRIS_STRONGEST Extract strongest Harris point.
%   HARRIS_STRONGEST(IM) extracts the strongest harris point in image IM.
%
%   HARRIS_STRONGEST(IM, SG, MRG, EDGEREJ) accepts additional inputs as
%   follows:
%
%   INPUT
%   =====
%   im     : the graylevel image
%   sigma  : STD of the smoothing mask in pixels
%   mrg    : inner margin to be ignored
%   edgerej: maximum ratio allowed between largest and smallest eigenvalues
%
%   [P,SC] = HARRIS_STRONGEST(...) returns also the point's strength as a
%   scalar score (non-normalized).
%
%   OUTPUT
%   ======
%   point  : the interest point extracted
%   sc     : strength of corner point
%
%   EXAMPLE
%   =======
%   [point,sc] = harris_strongest(im)

% Author :: Vincent Garcia - multiple point detector
% Date   :: 05/12/2007
%
% Author :: Joan Sola - strongest point detector, margin ignoring, edge
% rejection
% Date   :: 01/08/2008
%
% REFERENCES
% ==========
% C.G. Harris and M.J. Stephens. "A combined corner and edge detector",
% Proceedings Fourth Alvey Vision Conference, Manchester.
% pp 147-151, 1988.
%
% Alison Noble, "Descriptions of Image Surfaces", PhD thesis, Department
% of Engineering Science, Oxford University 1989, p45.
%
% C. Schmid, R. Mohrand and C. Bauckhage, "Evaluation of Interest Point Detectors",
% Int. Journal of Computer Vision, 37(2), 151-172, 2000.
%

persistent x dx dy ex g; % gaussian filter


% Input options management
switch nargin
    case 1
        sigma = 2;
        mrg = 0;
        edgerej = 20;
    case 2
        mrg = 0;
        edgerej = 20;
    case 3
        edgerej = 20;
end

% only luminance value
im = single(im(:,:,1));

% image size
[sx,sy] = size(im);

% derivative masks
s_D = 0.5*sigma;
if isempty(x)
    x  = -round(2.0*s_D):round(2.0*s_D);
    ex = exp(-x.*x/(2*s_D^2)) ./ (s_D*sqrt(2*pi));
    dx = s_D^2 * x .* ex;
    dy = dx';
    g = conv2(ex,ex');
    g = g/sum(sum(g));
end

% image derivatives
Ix = conv2(im, dx, 'same');
Iy = conv2(im, dy, 'same');

Ix2 = conv2(Ix.^2, g, 'same'); % Smoothed squared image derivatives
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g, 'same');

% interest point response
% Original Harris measure.
% k = 0.06; cim = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;	

% Alison Noble measure.
% cim = (Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps);

% Shi and Tomasi -- smallest eigenvalue
a = Ix2+Iy2;
b = sqrt((Ix2-Iy2).^2+4*Ixy.^2);
cim = a-b;  % Smallest eigenvalue.

% supress corner measures close to margin
cim([1:mrg sx-mrg+1:sx],:) = -9e9;
cim(:,[1:mrg sy-mrg+1:sy]) = -9e9;

% Find strongest corner [u;v] and score
[scv,v] = max(cim);
[sc,u]  = max(scv);     % score and u-coordinate
v       = v(u);         % v-coordinate

% reject edges
l = sc;                 % smallest eigenvalue is the score
L = a(v,u) + b(v,u);    %  largest eigenvalue
if L/l > edgerej        % reject edge detections
    sc = 0;             % return nothing if winner is an edge
end

point = [u;v];

% comment out this part for displaying purposes
% figure(98)
% imshow(im,[0 255]);colormap(gray(255))
% axis on
% hold on;
% sz = 3;
% rectangle('Position',[u-sz,v-sz,2*sz,2*sz],'Curvature',[0 0],'EdgeColor','b','LineWidth',1);
% figure(99)
% imshow(cim,[0 max(max(cim))]); axis on;colormap(gray(255))
% rectangle('Position',[u-sz,v-sz,2*sz,2*sz],'Curvature',[0 0],'EdgeColor','b','LineWidth',1);
% point;
% sc;



% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

