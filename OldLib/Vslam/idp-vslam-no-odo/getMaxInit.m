function maxNewInit = getMaxInit

% GETMAXINIT  Compute maximum allowable initializations
%   M = GETMAXINIT computes the maximum number of
%   initializations that are allowed given the current state of
%   the global landmark structure Lmk.
%   The following fields in global Lmk are used:
%     .Pnt.used : currently used points
%     .Ray.used : currently used rays
%     .maxRay   : maximum allowed rays
%     .maxPnt   : maximum allowed points
%     .maxInit  : maximum allowed simultaneous initializations

% (c) 2005 Joan Sola

global Lmk

numPnt = sum([Lmk.Pnt.used]); % points
numRay = sum([Lmk.Ray.used]); % rays

maxNewRay = Lmk.maxRay-numRay;   % max allowable new rays
maxNewPnt = Lmk.maxPnt-numPnt;   % max allowable new points

% maximum allowable initializations
maxNewInit = min([maxNewPnt maxNewRay Lmk.maxInit]);