function mapObs = mapObserver(world,mapView)

% MAPOBSERVER  Initialize observer camera for map plots



% Observer camera:
switch mapView
    case 'normal'
        % a. normal view
        az  = 0;  % azimut angle in degrees
        el  = 25; % elevation angle in degrees
        rd  = max([world.l,world.w,world.h]); % distance in metres
    case 'top'
        % b. top view
        az  = 90;
        el  = 90;
        rd  = max([world.l,world.w,world.h]);
    case 'side'
        % c. side view
        az  = 90;
        el = 0;
        rd = max([world.l,world.w,world.h]);
    case 'view'
        % d. view
        az = 41;
        el = 60;
        rd = max([world.l,world.w,world.h]);
    otherwise
        az = 0;
        el = 25;
        rd = max([world.l,world.w,world.h]);
end

az = deg2rad(az);
el = deg2rad(el);

% Observer target
R            = e2R([0,el,az]);
mapObs.tgt   = [world.xMean;world.yMean;0];
mapObs.X     = mapObs.tgt + rd*R*[-1;0;0];
mapObs.fov   = 40;
mapObs.upvec = R*[0;0;1];

