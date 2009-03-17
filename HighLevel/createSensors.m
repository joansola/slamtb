function Sen = createSensors(Sensor)

% CREATESENSORS Create sensors structure

% (c) 2009 Joan Sola @ LAAS-CNRS

for sen = 1:numel(Sensor)

    Si = Sensor{sen}; % input sensor structure

    % identification
    So.name  = Si.name;
    So.id    = sen;
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
    So.par.imSize = Si.imageSize;
    So.par.pixErr = Si.pixErrorStd;
    So.par.k = Si.intrinsic;
    So.par.d = Si.distortion;
    So.par.c = invDistortion(So.par.d,numel(So.par.d),So.par.k);

    % state
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
    
    switch So.type
        case {'pinHole'}
            So.graphics = camGraphics(0.1);
        otherwise
            So.graphics = camGraphics(0.1);
    end
    
    Sen(sen) = So; % output sensor structure

end

