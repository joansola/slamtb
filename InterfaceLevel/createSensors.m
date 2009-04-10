function Sen = createSensors(Sensor)

% CREATESENSORS Create sensors structure array.
%   Sen = CREATESENSORS(Sensor) creates the Sen() structure array to be
%   used as SLAM data. The input Sensor{}  is a cell array of structures as
%   specified by the user in userData.m. There must be one Sensor{} per
%   each sensor considered in the simulation. See userData.m for details.


% (c) 2009 Joan Sola @ LAAS-CNRS

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
            So.par.k = Si.intrinsic;
            So.par.d = Si.distortion;
            So.par.c = invDistortion(So.par.d,numel(So.par.d),So.par.k);

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

end

