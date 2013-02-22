function H = frame2iMatrix(F)

% FRAME2IMATRIX Frame to inverse motion matrix.
%   FRAME2IMATRIX(F) is the 4-by-4 motion matrix corresponding to the
%   inverse of the frame transformation F, i.e.,
%       [F.Rt   F.it
%         0      1  ]
%
%   See also FRAME2IMOTION, FRAME.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

H = [F.Rt F.it;0 0 0 1];









