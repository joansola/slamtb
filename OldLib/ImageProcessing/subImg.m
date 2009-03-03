function im = subImg(rect,m)

% SUBIMG  Rectangular sub image
%   IM = SUBIMG(R) gets the rectangular portion of global image
%   Image inside the bounds defined by the rectangle 
%   vector R=[xmin xmax ymin ymax]. 
%
%   IM = SUBIMG(R,M) first thickens the rectangle with M pixels
%   at all margins. This allows to cut an interest image and to
%   obtain a certain additional margin.
%

global Image

if nargin == 2
    rect = rect + [-m m -m m];
end

rect1 = reshape(rect,2,[])';

sze = rc2hv(size(Image))';
if rect1 < 1 | rect1 > [sze sze]
    error('Specified rectangle is out of Image bounds')
else
    rx = rect(1):rect(2);
    ry = rect(3):rect(4);
    im = Image(ry,rx);
end

