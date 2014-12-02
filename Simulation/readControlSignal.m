function Rob = readControlSignal(Rob,frm,ExpOpt)

% READCONTROLSIGNAL  Read robot-s control signal from file.
%   R = READCONTROLSIGNAL(R,F) reads the control signal for robot R
%   corresponding to frame F. R is a Rob structure in SLAMTB. F is an
%   integer corresponding to the frame number.
%
%   The file read has the following name format
%       Directory: ./data/ <ExpOpt.site> /
%       Name: ExpOpt.controlName , e.g. 'control-r%02d-i%06d.txt'
%   where the first index is the robot number (2 digits) and the second is
%   the frame number (6 digits). 
%   The file contains two lines: the control vector and covariances matrix:
%           u1 u2 u3 ... un
%           U11 U12 ... U1n U21 U22 ... Unn
%   where n is the dimension of the control vector.
%
%   See also WRITECONTROLSIGNAL, WRITEPROCESSEDIMG, READPROCESSEDIMG.

%   Copyright 2013 Joan Sola


if strcmp(Rob.motion, 'odometry')
    
dir = [ExpOpt.root  'data/' ExpOpt.site '/'];
    filename = sprintf(ExpOpt.controlName, Rob.rob, frm);
    filepath = [dir filename];

    fid      = fopen(filepath,'r');
    
    u = str2num(fgetl(fid))';
    n = numel(u);
    
    U_line = str2num(fgetl(fid));
    
    U = reshape(U_line, n, n);
    
    Rob.con.u = u;
    Rob.con.U = U;
    
    fclose(fid);

else
    Rob.con.u = zeros(6,1);
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

