function writeControlSignal(Rob,frm,ExpOpt)

% WRITECONTROLSIGNAL  Write robot's control signal to file.
%   WRITECONTROLSIGNAL(R,F) writes a file with the the control signal for
%   robot R corresponding to frame F. R is a Rob structure in SLAMTB. F is
%   an integer corresponding to the frame number.
%
%   The file written has the following name format
%       Directory: ./data/
%       Name: control-RR-FFFFFF.txt
%   where RR is the robot number (2 digits) and FFFFFF is the frame number
%   (6 digits).
%   The file contains two lines: the control vector and covariances matrix:
%           u1 u2 u3 ... un
%           U11 U12 ... U1n U21 U22 ... Unn
%   where n is the dimension of the control vector.
%
%   See also READCONTROLSIGNAL, READPROCESSEDIMG, WRITEPROCESSEDIMG.

%   Copyright 2013 Joan Sola

dir = [ExpOpt.root  'data/' ExpOpt.sensingType '/'];
if ~isdir(dir)
    mkdir(dir);
end
filename = sprintf('control-r%02d-i%06d.txt', Rob.rob, frm);
filepath = [dir filename];

fid = fopen(filepath,'w');

u = Rob.con.u + Rob.con.uStd.*randn(size(Rob.con.uStd));
U = Rob.con.U;

count = fprintf(fid,'%f\t',u);
count = fprintf(fid,'\n');
count = fprintf(fid,'%f\t',U);
count = fprintf(fid,'\n');

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

