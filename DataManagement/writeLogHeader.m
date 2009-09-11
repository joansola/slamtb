function writeLogHeader(fid,header)

% WRITELOGHEADER  Write log file header.
%   WRITELOGHEADER(FID,TEXT) writes the line of text TEXT in hte log file
%   identified by FID. FID is created by the function OPENLOGFILE.
%
%   See also OPENLOGFILE, WRITELOGDATA, CLOSELOGFILE, FPRINTF.

fprintf(fid,[header '\n']);

