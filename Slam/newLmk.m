function lmk = newLmk(Lmk)

% NEWLMK  Get a new landmark.
%   NEWLMK(Lmk) returns the index in structure array Lmk() of the first
%   non-used landmark.
%
%   See also NEWRANGE, INITNEWLMKS.

% Copyright 2009-2009 Joan sola @ LAAS-CNRS.

lmk = find(~[Lmk.used],1,'first');
