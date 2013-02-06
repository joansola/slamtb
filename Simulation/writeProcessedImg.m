function writeProcessedImg(rob,sen,frm,Raw)

% WRITEPROCESSEDIMG  Write processed image data to file.
%   WRITEPROCESSEDIMG(R,S,F,Raw) writes the processed image in Raw for
%   sensor S in robot R corresponding to frame F. R and S are Rob and Sen
%   structures in SLAMTB. F is an integer corresponding to the frame
%   number.
%
%   The processed image contains simply the coordinates of all the features
%   detected, with an identifier. See below for the file format.
%
%   The file written has the following name format
%       Directory: ./data/
%       Name: img-RR-SS-FFFFFF.txt 
%   where RR and SS are the robot and sensor numbers (2 digits each) and
%   FFFFFF is the frame number (6 digits).
%   The file contains one line per feature, containing identifier and UV
%   coordinates separated by tabs:
%           id1  U1  V1
%           id2  U2  V2
%           ...
%           idn  Un  Vn
%
%   See also READPROCESSEDIMG, WRITECONTROLSIGNAL, READCONTROLSIGNAL.

%   Copyright 2013 Joan Sola

filename = sprintf('./data/img-r%02d-s%02d-i%06d.txt',rob,sen,frm);
fid = fopen(filename,'w');
ids = Raw.data.points.app;
coord = Raw.data.points.coord;
for i = 1:numel(ids)
    count = fprintf(fid,'%02d\t%f\t%f\n',ids(i),coord(1,i),coord(2,i));
end
fclose(fid);



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

%   SLAMTB is Copyright 2007, 2008, 2009, 2010, 2011, 2012 
%   by Joan Sola @ LAAS-CNRS.
%   SLAMTB is Copyright 2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

