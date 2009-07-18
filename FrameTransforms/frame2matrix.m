function H = frame2matrix(F)

% FRAME2MATRIX Frame to motion matrix.
%   FRAME2MATRIX(F) is the 4-by-4 motion matrix corresponding to the frame
%   transformation F, i.e.,
%       [F.R   F.t
%         0     1 ]
%
%   See also FRAME2IMOTION, FRAME.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

H = [F.R F.t;0 0 0 1];
