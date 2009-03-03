% function  [maxLm,maxMapSize] = displayMaxUsed(maxLm,maxMapSize);
function  [maxLm] = displayMaxUsed(maxLm);

global Map
persistent maxMapSize

% maximum attained map size
if isempty(maxMapSize)
    maxMapSize = 0;
end

if Map.n > maxMapSize
    maxMapSize = Map.n;
    maxX = Map.n*[1 1];
    set(maxLm,...
        'xdata',maxX);
end
