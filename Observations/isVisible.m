function vis = isVisible(pix,depth,imSize,mrg)

% ISVISIBLE  Points visible from pinHole camera.
%   ISVISIBLE(PIX,DEPTH,IMSIZE) returns TRUE for those pixels in pixels
%   matrix PIX that are in front of the camera (DEPTH>0) and within the
%   limits defined by IMSIZE.
%  
%   ISVISIBLE(PIX,DEPTH,IMSIZE,MARGIN) considers a point inside the image
%   if it is further than MARGIN units from its borders.
%  
%   IMSIZE is defined by IMSIZE = [hsize vsize].
%  
%   PIX is a 2D-pixels matrix : PIX = [P1 ... PN] ,
%   with Pi = [ui;vi].
%
%   See also INSQUARE.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

%   TODO : check a better visibility criterion for negative inverse depth
%   management. Use the variance in RHO for this.


if nargin < 4
    mrg = 0;
end

vis = inSquare(pix,[0 imSize(1) 0 imSize(2)],mrg) & (depth > 0);









