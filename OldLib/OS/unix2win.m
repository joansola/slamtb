function filename = unix2win(filename)

% UNIX2WIN  Translate file names from Unix to Windows
%
%   F = UNIX2WIN(F) changes all '\' with '/'.
%
%   See alse WIN2UNIX

idx = find(filename == '/');
filename(idx) = '\';
