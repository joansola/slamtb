% INITOBSERVER  Initialize observer camera for plots


% Observer target
obsTgt.X = [(xmin+xmax)/2;(ymin+ymax)/2;(zmin+zmax)/2];

% Observer camera:
switch mapView
    case 'normal'
        % a. normal view
        az  = 0;  % azimut angle in degrees
        el  = 25; % elevation angle in degrees
        rd  = xmax; % distance in metres
    case 'top'
        % b. top view
        az  = 90;
        el  = 90;
        rd  = xmax-xmin;
    case 'side'
        % c. side view
        az  = 90;
        el = 0;
        rd = xmax;
    case 'view'
        % d. view
        az = -30;
        el = 30;
        rd = xmax;
    otherwise
        az = 0;
        el = 25;
        rd = xmax;
end

az = deg2rad(az);
el = deg2rad(el);

obsCam.a     = 45;
obsCam.R     = e2R([0,el,az]);
obsCam.X     = obsTgt.X + rd*obsCam.R*[-1;0;0];
obsCam.upvec = obsCam.R*[0;0;1];
