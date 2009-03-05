function Rob = initRobots(Rob)

% INITROBOTS Initialize robots in Map.

% (c) 2009 Joan Sola @ LAAS-CNRS

for rob = 1:numel(Rob)

    fr = addToMap(Rob(rob).frame.x,Rob(rob).frame.P); % frame range in Map
    vr = addToMap(Rob(rob).vel.x,Rob(rob).vel.P);     % velocity range
    
    Rob(rob).frame.r = fr;
    Rob(rob).vel.r   = vr;
    Rob(rob).r       = [fr;vr];   % robot's state range

end
