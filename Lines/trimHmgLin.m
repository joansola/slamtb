function e = trimHmgLin(H,imSize)

% TRIMHMGLIN  Trim 2D homogeneous line at image borders
%   TRIMHMGLIN(H,IMSIZE) trims the line H at the image borders specified by
%   IMSIZE. IMSIZE is a 2-vector with the image dimensions in pixels,
%   IMSIZE = [HSIZE,VSIZE]. The output is a segment segment.
%
%   See also TRIMSEGMENT.
%
%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

%   TRIMHMGLIN(...,MRG) restricts the image size to be smaller in MRG
%   pixels at its four borders.

% image dimensions
[w,h] = split(imSize);

% image borders - homogeneous lines
L = [1; 0; 0];  % left image border
R = [1; 0;-w];  % right
T = [0; 1; 0];  % top
B = [0; 1;-h];  % bottom

% intersections of infinite line with infinite borders
HL = intersectHmgLin(H,L,1);
HR = intersectHmgLin(H,R,1);
HT = intersectHmgLin(H,T,1);
HB = intersectHmgLin(H,B,1);

% bring to image borders
i = 1;
if inInterval(HL(2),[0,h])
    e(i:i+1,1) = HL;
    i = 3;
end
if inInterval(HR(2),[0,h])
    e(i:i+1,1) = HR;
    i = 3;
end
if inInterval(HT(1),[0,w])
    e(i:i+1,1) = HT;
    i = 3;
end
if inInterval(HB(1),[0,w])
    e(i:i+1,1) = HB;
end

if i == 1 % no intersection with image borders
    % Segment is not visible
    e = [];
end


return

%% test
imsize = [10 10];
h{1}  = [1 2 3]';
h{2}  = [-1 2 3]';
h{3}  = [1 -2 3]';
h{4}  = [1 2 -3]';
h{5}  = [1 2 3]';
h{6}  = [1 2 3]';
h{7}  = [1 2 11]';
h{8}  = [1 11 3]';
h{9}  = [11 2 3]';
h{10} = [-1 -2 13]';
h{11} = [13 14 -1]';

for i=1:numel(h)
    h{i}'
    (trimHmgLin(h{i},imsize))'
end



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

