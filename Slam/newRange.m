function r = newRange(size)

global Map

u = find(~Map.used);

r = u(1:size);

return

%% test
global Map

Map.used = [0 0 0 4 5 0 7 8 0 0 0 12 0 0]';

r = newRange(6)
