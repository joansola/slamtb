function [Rob,Sen] = installSensors(Rob,Sen)

% INSTALLSENSORS  Install sensors on robots.
%   [Rob, Sen] = INSTALLSENSORS(Rob, Sen) installs each sensor in Sen on
%   the robot Rob(rob), with rob = Sen(sen).robot. Installation is done
%   by augmenting the vector in field Rob(rob).sensors with the new sensor.

% (c) 2009 Joan Sola @ LAAS-CNRS


for sen = 1:numel(Sen)

    rob = Sen(sen).robot;

    if rob > numel(Rob)
        error('Attempt to install sensor on inexistent robot.');
    else

        Rob(rob).sensors = [Rob(rob).sensors sen];
    end
end
