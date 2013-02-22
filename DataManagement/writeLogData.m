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








