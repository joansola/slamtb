function Sen = createSensors(Sensor)

% CREATESENSORS Create sensors structure

% (c) 2009 Joan Sola @ LAAS-CNRS

for sen = 1:numel(Sensor)

    Si = Sensor{sen};

    % identification
    So.name  = Si.name;
    So.id    = sen;
    So.type  = Si.type;
    
    So.robot = [];

    % frame
    ep = [Si.position;deg2rad(Si.orientationDegrees)];
    EP = diag([Si.positionStd;deg2rad(Si.orientationStd)].^2);

    [qp,QP] = propagateUncertainty(ep,EP,@epose2qpose); % frame and cov. in quaternion

    So.frame.X  = qp;
    So.frame.P  = QP;
    So.frame    = updateFrame(So.frame);    
    So.frame.r  = [];

    % transducer
    So.imSize = Si.imageSize;
    So.pixErr = Si.pixErrorStd;
    So.k = Si.intrinsic;
    So.d = Si.distortion;
    So.c = distorsion(So.d,numel(So.d),So.k);

    % general
    if Si.frameInMap
        So.x    = So.frame.X;
        So.P    = So.frame.P;
        So.size = numel(So.x);
    else
        So.x    = [];
        So.P    = [];
        So.size = 0;
    end
    So.r     = [];
    
    switch So.type
        case {'pinHole'}
            So.graphics = camGraphics(0.1);
        otherwise
            So.graphics = camGraphics(0.1);
    end
    
    Sen(sen) = So;

end

