% INITOBSERVER  Initialize observer camera for plots


% Observer target
obsTgt.X = [10;0;0];

% Observer camera:
switch mapView
    case 'normal'
        % a. normal view
        az  = 0;  % azimut angle in degrees
        el  = 25; % elevation angle in degrees
        rd  = 20; % distance in metres
    case 'top'
        % b. top view
        az  = 90;
        el  = 90;
        rd  = 15;
    case 'side'
        % c. side view
        az  = 90;
        el = 0;
        rd = 25;
    case 'view'
        % d. view
        az  = -10;
        el = 14;
        rd = 25;
    otherwise
        az = 0;
        el = 25;
        rd = 25;
end

az = deg2rad(az);
el = deg2rad(el);

obsCam.a     = 50;
obsCam.R     = e2R([0,el,az]);
obsCam.X     = obsTgt.X + rd*obsCam.R*[-1;0;0];
obsCam.upvec = obsCam.R*[0;0;1];
