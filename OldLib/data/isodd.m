function e = isodd(n)

% ISODD  True for arrays of odd integer data values
%   ISODD(N) returns a booloean array of the same size of N with
%   trues where N is odd and falses elsewhere.
%
%   Exemple:
%     isodd([2.5 4 5]) = [0 0 1]
%
%   See also ISEVEN

% (c) 2006 Joan Sola

e = (floor((n+1)/2) == (n+1)/2);