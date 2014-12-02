function writeLogData(fid,data,format)

% WRITELOGDATA  Write log data in file.
%   WRITELOGDATA(FID,DATA) writes the line of data DATA in hte log file
%   identified by FID. FID is created by the function OPENLOGFILE.
%
%   See also OPENLOGFILE, WRITELOGHEADER, CLOSELOGFILE, FPRINTF.

if nargin == 2
    n = length(data);
    format = '%d';
    for i = 1:n-1
        format = [format ' %f'];
    end
    format = [format '\n'];
end

fprintf(fid,format,data);

end
% return

%%
% fid = fopen('lala.log','w');
% writeLogHeader(fid,'f x');
% writeLogData(fid,3);
% fclose(fid);

%%



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

