function Pi = pi2pc(Pi)

% PI2PC  Pi matrix to conjugated Pi matrix conversion.
%   PC = PI2PC(PI) converts the matrix
%       PI = QUAT2PI(Q)
%   into 
%       PC = QUAT2PI(QC)
%   where QC = Q2QC(Q), the conjugated quaternion.
%
% See also Q2QC, Q2PI, TOFRAME


Pi([1 3 4 5 6 8 9 10 11]) = -Pi([1 3 4 5 6 8 9 10 11]);
