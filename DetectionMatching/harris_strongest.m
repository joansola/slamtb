function [point,sc] = harris_strongest(im,sigma,mrg,edgerej)
% Extract strongest keypoint using Harris algorithm (with an improvement
% version)
%
% Author :: Vincent Garcia - multiple point detector
% Date   :: 05/12/2007
%
% Author :: Joan Sola - strongest point detector, margin ignoring, edge
% rejection
% Date   :: 01/08/2008
%
% INPUT
% =====
% im     : the graylevel image
% sigma  : STD of the smoothing mask in pixels
% mrg    : inner margin to be ignored
% edgerej: maximum ratio allowed between largest and smallest eigenvalues
%
% OUTPUT
% ======
% point  : the interest point extracted
% sc     : strength of corner point
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
% EXAMPLE
% =======
% [point,sc] = kp_harris(im)

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
im = double(im(:,:,1));

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
% cim = (Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps);				% Alison Noble measure.
% k = 0.06; cim = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;	% Original Harris measure.

a = Ix2+Iy2;
b = sqrt((Ix2-Iy2).^2+4*Ixy.^2);
cim = a-b;  % Smallest eigenvalue.

% supress corner measures close to margin
cim([1:mrg sx-mrg:sx],:) = -9e9;
cim(:,[1:mrg sy-mrg:sy]) = -9e9;

% Find strongest corner
[scr,r] = max(cim);
[sc,c]  = max(scr);
r       = r(c);

% reject edges
l = sc;              % smallest eigenvalue
L = a(r,c) + b(r,c); %  biggest eigenvalue
if L/l > edgerej
    sc = 0;
end

point = [c;r];

% comment out this part for displaying purposes
% figure(98)
% imshow(im,[0 255]);colormap(gray(255))
% axis on
% hold on;
% sz = 3;
% rectangle('Position',[c-sz,r-sz,2*sz,2*sz],'Curvature',[0 0],'EdgeColor','b','LineWidth',1);
% figure(99)
% imshow(cim,[0 max(max(cim))]); axis on;colormap(gray(255))
% rectangle('Position',[c-sz,r-sz,2*sz,2*sz],'Curvature',[0 0],'EdgeColor','b','LineWidth',1);
% point;
% sc;
