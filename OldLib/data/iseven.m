function e = iseven(n)

% ISEVEN  True for arrays of even integer data values
%   ISEVEN(N) returns a booloean array of the same size of N with
%   trues where N is even and falses elsewhere.
%
%   Exemple:
%     iseven([2.5 4 5]) = [0 1 0]
%
%   See also ISODD

% (c) 2006 Joan Sola

e = (floor(n/2) == n/2);