function Rob = initRobots(Rob)

if Ro.frameInMap
    fr = newRange(7);
    Ro.fr = fr;
    Map.used(fr) = fr;

    tStd = Ri.positionStd;
    eStd = deg2rad(Ri.orientationStd);
    eposeCov = diag([tStd;eStd].^2);
    [f,fCov] = propagateUncertainty(Ro.f.X,eposeCov,@epose2qpose);

    Map.x(fr) = Ro.f.X;
    Map.P(fr,fr) = fCov;

end

