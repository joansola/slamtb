% INITOBSERVER  Initialize observer camera for plots


% Observer target
obsTgt.X = [xSize/2;0;0];
rd = 0.8*xSize;

% Observer camera:
switch mapView
    case 'normal'
        % a. normal view
        az  = 0;  % azimut angle in degrees
        el  = 25; % elevation angle in degrees
        rd  = rd; % distance in metres
    case 'top'
        % b. top view
        az  = 90;
        el  = 90;
        rd  = rd;
    case 'side'
        % c. side view
        az  = 90;
        el = 0;
        rd = rd;
    case 'view'
        % d. view
        az  = -10;
        el = 14;
        rd = rd;
    otherwise
        az = 0;
        el = 25;
        rd = rd;
end

az = deg2rad(az);
el = deg2rad(el);

obsCam.a     = 50;
obsCam.R     = e2R([0,el,az]);
obsCam.X     = obsTgt.X + rd*obsCam.R*[-1;0;0];
obsCam.upvec = obsCam.R*[0;0;1];
