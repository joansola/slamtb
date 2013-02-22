function fid = openLogFile(filename,mode)

% OPENLOGFILE  Open log file.
%   FID = OPENLOGFILE(FILENAME,MODE) opens the file FILENAME in MODE mode.
%   The mode MODE is a string in {'r','read','w','write'}. FID is the file
%   identifer used in other IO functions.
%
%   See also WRITELOGHEADER, WRITELOGDATA, CLOSELOGFILE, FOPEN.

switch mode
    case {'r','read'}
        m = 'r';
    case {'w','write'}
        m = 'w';
end

fid =fopen(filename,m);









