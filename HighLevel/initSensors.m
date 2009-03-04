function Sen = initSensors(Sen)

% INITSENSORS Initialize sensors in Map.

% (c) 2009 Joan Sola @ LAAS-CNRS

for sen = 1:numel(Sen)

    r = addToMap(Sen(sen).state.x,Sen(sen).state.P);

    Sen(sen).frame.r = r;
    Sen(sen).state.r = r;

end
