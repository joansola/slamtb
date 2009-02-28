function Map = createMap(Rob,Sen,Lmk)

n = sum([Rob.size]) + sum([Sen.size]) + sum([Lmk.size]);

Map.used = zeros(n,1);

Map.x = zeros(n,1);
Map.P = zeros(n,n);

Map.size = n;

% Map.robots = [Rob.id];  % do it in initRobots.m
% Map.sensors = [Sen.id]; % do it in initSensors.m
