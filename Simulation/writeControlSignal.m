function writeControlSignal(Rob,frm,ExpOpt)

% WRITECONTROLSIGNAL  Write robot's control signal to file.
%   WRITECONTROLSIGNAL(R,F) writes a file with the the control signal for
%   robot R corresponding to frame F. R is a Rob structure in SLAMTB. F is
%   an integer corresponding to the frame number.
%
%   The file written has the following name format
%       Directory: ./data/
%       Name: ExpOpt.controlName , e.g. 'control-r%02d-i%06d.txt'
%   where the first index is the robot number (2 digits) and the second is
%   the frame number (6 digits). 
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
filename = sprintf(ExpOpt.controlName, Rob.rob, frm);
filepath = [dir filename];

fid = fopen(filepath,'w');

u = Rob.con.u + Rob.con.uStd.*randn(size(Rob.con.uStd));
U = Rob.con.U;

count = fprintf(fid,'%f\t',u);
count = fprintf(fid,'\n');
count = fprintf(fid,'%f\t',U);
count = fprintf(fid,'\n');

fclose(fid);









