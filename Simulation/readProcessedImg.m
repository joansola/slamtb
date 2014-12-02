function Raw = readProcessedImg(rob,sen,frm,ExpOpt)

% READPROCESSEDIMG  Read processed image data from file.
%   Raw = READPROCESSEDIMG(R,S,F) reads the processed image for sensor S in
%   robot R corresponding to frame F, and store it in structure Raw. R and
%   S are Rob and Sen structures in SLAMTB. F is an integer corresponding
%   to the frame number.
%
%   The processed image contains simply the coordinates of all the features
%   detected, with an identifier. See below for the file format.
%
%   The file read has the following name format
%       Directory: ./data/ <ExpOpt.site> /
%       Name: ExpOpt.procImgName , e.g. 'procImg-r%02d-s%02d-i%06d.txt'
%   where the first two indices are the robot and sensor numbers (2 digits
%   each) and the third is the frame number (6 digits). The file contains
%   one line per feature, containing identifier and UV coordinates
%   separated by tabs:
%           id1  U1  V1
%           id2  U2  V2
%           ...
%           idn  Un  Vn
%
%   An image file is also read and set to Raw structure if it exists in the
%   data path ./data/. Its name format is stored in ExpOpt.imgName.
%
%   See also WRITEPROCESSEDIMG, READCONTROLSIGNAL, WRITECONTROLSIGNAL.

%   Copyright 2013 Joan Sola

Raw.type = 'dump'; % Pre-processed images

dir = [ExpOpt.root  'data/' ExpOpt.site '/'];
filename = sprintf(ExpOpt.procImgName,rob,sen,frm);
filepath = [dir filename];

fid      = fopen(filepath,'r');

M        = fscanf(fid,'%f',[3, inf]);

Raw.data.points.app   = M( 1 ,:); % Appearances will be used as identifiers
Raw.data.points.coord = M(2:3,:); % Coordinates of pixels

Raw.data.segments.app   = [];
Raw.data.segments.coord = [];

fclose(fid);

imgname = sprintf(ExpOpt.imgName,rob,sen,frm); % Let imread below guess file format
imgpath = [dir imgname];

if exist(imgpath,'file')
    % there is an image file
    Raw.data.img = imread(imgpath);
    if size(Raw.data.img,3) > 1
        Raw.data.img = rgb2gray(Raw.data.img);
    end
    
else
        Raw.data.img = [];

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

