function Sen = initSensors(Sen)

% INITSENSORS Initialize sensors in Map.
%   Sen = INITSENSORS(Sen) initializes all sensors in Sen() in the global
%   map Map. It does so by:
%       getting a range of free states for the sensor
%       assigning it to the appropriate fields of Sen
%       setting Sen's mean and cov. matrices in Map
%       setting all Map.used positions in the range to 'true'.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

for sen = 1:numel(Sen)

    r = addToMap(Sen(sen).state.x,Sen(sen).state.P);

    Sen(sen).frame.r = r;
    Sen(sen).state.r = r;

end









