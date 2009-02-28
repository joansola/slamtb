function Sen = initSensors(Sen)

% INITSENSORS Initialize sensors in Map.

% (c) 2009 Joan Sola @ LAAS-CNRS

for sen = 1:numel(Sen)

    r = addToMap(Sen(sen).x,Sen(sen).P);

    Sen(sen).frame.r = r;
    Sen(sen).r = r;

end
