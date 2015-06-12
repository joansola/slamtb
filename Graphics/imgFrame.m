function imgFrame(fig,file,ax)

% IMGFRAME  Exports figure graphics to image file.
%   IMGFRAME(FIG,FILE) creates from the graphics contents of FIG 
%   a image file FILE.
%
%   IMGFRAME(FIG,FILE,AX) uses the contents of axes AX in
%   figure FIG instead.
%
%   Examples:
%       imgFrame(1,'image.png',gca) exports the current axes in figure 1.
%       imgFrame(gcf,'image.png') exports the current figure.
%       imgFrame(1,sprintf('image-%03d.png',t)) for loops governed by index
%           t, exports the figure 1 at time t. Use it to make movies.
%
%   See also GETFRAME, FRAME2IM, IMWRITE.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

% figure(fig)
if nargin < 3
    frmh = fig;
else
    frmh = ax;
end

% drawnow
frm = getframe(frmh);
im  = frame2im(frm);
imwrite(im,file);



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
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

