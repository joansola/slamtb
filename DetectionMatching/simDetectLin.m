function [newId, meas, exp, inn] = simDetectLin(lmkIds, raw, pixCov)

% SIMDETECTLIN  Detect 2D segment in simulated raw data.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

apps  = raw.segments.app;

[newIds,newIdsIdx] = setdiff(apps,lmkIds);

if ~isempty(newIds)
    newId    = newIds(1);
    newIdx   = newIdsIdx(1);

    % best new point coordinates and covariance
    y = raw.segments.coord(:,newIdx);
    R = blkdiag(pixCov,pixCov);

    meas.y = y;
    meas.R = R;
    [exp.e,exp.E] = propagateUncertainty(y,R,@seg2hmgLin);
    inn.z  = [0;0];
    inn.Z  = R;


else

    newId  = [];
    meas.y = [];
    meas.R = [];
    exp.e  = [];
    exp.E  = [];
    inn.z  = [];
    inn.Z  = [];

end


