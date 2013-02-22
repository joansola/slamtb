function Rob = readControlSignal(Rob,frm,ExpOpt)

% READCONTROLSIGNAL  Read robot-s control signal from file.
%   R = READCONTROLSIGNAL(R,F) reads the control signal for robot R
%   corresponding to frame F. R is a Rob structure in SLAMTB. F is an
%   integer corresponding to the frame number.
%
%   The file read has the following name format
%       Directory: ./data/
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
    
    dir = [ExpOpt.root  'data/' ExpOpt.sensingType '/'];
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








