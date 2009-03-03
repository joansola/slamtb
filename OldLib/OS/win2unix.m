function filename = win2unix(filename)

% WIN2UNIX  Translate file names from Windows to Unix
%
%   F = WIN2UNIX(F) changes all '\' with '/'.
%
%   See alse UNIX2WIN

idx = find(filename == '\');
filename(idx) = '/';
