function Rob = initRobots(Rob)

% INITROBOTS Initialize robots in Map.

% (c) 2009 Joan Sola @ LAAS-CNRS

for rob = 1:numel(Rob)

    fr = addToMap(Rob(rob).frame.x,Rob(rob).frame.P); % range in Map
    vr = addToMap(Rob(rob).vel.x,Rob(rob).vel.P);
    
    Rob(rob).frame.r = fr;
    Rob(rob).vel.r = vr;
    Rob(rob).r  = [fr;vr];

end
