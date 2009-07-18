function [T,R,Rt] = getTR(F)

% GETTR Get translation vector and rotation matrix
%
% [T,R] = GETTR(F) gets version of T and R
% from frame S, where S is a structure containing:
%   X = [T;Q] : frame
%   R : rotation matrix
%
% [T,R,Rt] = GETTR(...) gives also the transposed R

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

T = F.t;
R = F.R;
if nargout == 3
    Rt = F.Rt;
end

