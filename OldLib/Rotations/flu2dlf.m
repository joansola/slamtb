function Rb2s = flu2dlf

% FLU2DLF Camera body to camera sensor rotation matrix
%   FLU2DLF computes the rotation matrix for a camera whos body
%   is in the FLU frame (x-front, y-left, z-up) and its sensor in
%   the DLF frame (x-down, y-left, z-front)

Rb2s = e2R([0 pi/2 0]');
