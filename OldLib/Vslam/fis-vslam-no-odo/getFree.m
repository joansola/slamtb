function i = getFree(used)

% GETFREE  Get free position
%   GETFREE(USED)  returns the index to the first null element of
%   vector USED.
%

% (c) 2005 Joan Sola

i = find(used == 0,1);