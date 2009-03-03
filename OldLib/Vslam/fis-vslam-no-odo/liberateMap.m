function liberateMap(loc)

% LIBERATEMAP  Liberate landmarks in the map
%   LIBERATEMAP(LOC) liberates all locations in Map.used 
%   specified in LOC and fills the free space in Map.free
%   with them. It updates map size acordingly

global Map WDIM


Map.free(loc) = loc; % update map free space
Map.used(loc) = 0;   % update map used space

% resize map
maxUsed = max(Map.used);
if  maxUsed < Map.n
    Map.n = maxUsed;
    Map.m = loc2state(maxUsed)+WDIM-1;
end
