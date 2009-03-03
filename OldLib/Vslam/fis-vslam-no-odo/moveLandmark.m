function Lmk = moveLandmark(Lmk,newLoc)

% MOVELANDMARK  Move landmark in the map
%
%   LMK = MOVELANDMARK(LMK) takes landmark located at
%   position LOC and moves it to the lowest available free
%   position.
%
%   LMK = MOVELANDMARK(LMK,NEWLOC) moves it to the
%   specified location NEWLOC

%   (c) 2005 Joan Sola

global Map WDIM %pntTab

if nargin < 2
    newLoc = getLoc;
end

oldLoc = Lmk.loc;

if newLoc < oldLoc

    newRng = loc2range(newLoc);
    oldRng = loc2range(oldLoc);

    mapRng = 1:Map.m;

    % rearrange map
    Map.X(newRng) = Map.X(oldRng);
    Map.P(newRng,mapRng) = Map.P(oldRng,mapRng);
    Map.P(mapRng,newRng) = Map.P(mapRng,oldRng);
    Map.P(newRng,newRng) = Map.P(oldRng,oldRng);

    % rearrange free and used spaces
    Map.free([newLoc oldLoc]) = [0 oldLoc];
    Map.used([newLoc oldLoc]) = [newLoc 0];

    if oldLoc == Map.n % if it was the last
        % update map size
        Map.n = max(Map.used);
        Map.m = loc2state(Map.n)+WDIM-1;
    end

    % update lmk location with new one
    Lmk.loc = newLoc;

end

