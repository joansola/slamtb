function [Rob,Sen] = installSensors(Rob,Sen)

% INSTALLSENSORS  Associate sensors to robots.

% (c) 2009 Joan Sola @ LAAS-CNRS

for rob = 1:numel(Rob)
    
    R = Rob(rob);
    
    for sen = R.sensors
        
        if isempty(Sen(sen).robot)
            Sen(sen).robot = R.id;
        else
            error(...
                'Attempt to assign sensor %d to different robots %d and %d.',...
                sen,Sen(sen).robot,rob)
        end
        
    end
end
