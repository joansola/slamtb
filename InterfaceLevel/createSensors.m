function [Sen,Raw] = createSensors(Sensor)

% CREATESENSORS Create sensors structure array.
%   Sen = CREATESENSORS(Sensor) creates the Sen() structure array to be
%   used as SLAM data. The input Sensor{}  is a cell array of structures as
%   specified by the user in userData.m. There must be one Sensor{} per
%   each sensor considered in the simulation. See userData.m for details.
%
%   [Sen,Raw] = CREATESENSORS(...) creates an empty Raw structure for each
%   sensor.


%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

for sen = 1:numel(Sensor)

    Si = Sensor{sen}; % input sensor structure

    % identification
    So.sen   = sen;
    So.id    = Si.id;
    So.name  = Si.name;
    So.type  = Si.type;

    So.robot = Si.robot;

    % frame
    ep = [Si.position;deg2rad(Si.orientationDegrees)];
    EP = diag([Si.positionStd;deg2rad(Si.orientationStd)].^2);

    [qp,QP] = propagateUncertainty(ep,EP,@epose2qpose); % frame and cov. in quaternion

    So.frame.x  = qp;
    So.frame.P  = QP;
    So.frame    = updateFrame(So.frame);
    So.frame.r  = [];

    % transducer parameters
    switch So.type
        case {'pinHole'}
            So.par.imSize = Si.imageSize;
            So.par.pixErr = Si.pixErrorStd;
            So.par.pixCov = Si.pixErrorStd^2*eye(2);
            So.par.k = Si.intrinsic; % intrinsic parameters
            So.par.d = Si.distortion; % radial distortion coefficients
            So.par.c = invDistortion(...
                So.par.d,...
                numel(So.par.d)+1,...
                So.par.k); % distortion correction coefficients
            So.par.c = So.par.c(:);

        case {'omniCam'}
            So.par.imSize = Si.imageSize;
            So.par.pixErr = Si.pixErrorStd;
            So.par.pixCov = Si.pixErrorStd^2*eye(2);
            So.par.k  = Si.intrinsic;     % intrinsic parameters
            So.par.d  = Si.distortion;    % distortion polynom coefficients
            So.par.c  = Si.invDistortion; % distortion polynom coefficients
            
        otherwise
            error('??? Unknown sensor type ''%s''.',Si.type)

    end

    % state
    So.frameInMap     = Si.frameInMap;
    if Si.frameInMap
        So.state.x    = So.frame.x;
        So.state.P    = So.frame.P;
        So.state.size = numel(So.state.x);
    else
        So.state.x    = [];
        So.state.P    = [];
        So.state.size = 0;
    end
    So.state.r     = [];  % robot is not yet in the Map.

    Sen(sen) = So; % output sensor structure

    % Create empty Raw structure
    Raw(sen).type = '';
    Raw(sen).data = struct([]);

end



% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

