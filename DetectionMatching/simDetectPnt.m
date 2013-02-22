function [newId, meas, exp, inn] = simDetectPnt(lmkIds, raw, pixCov, imSize)

%SIMDETECTPNT Detect 2D point in simulated Raw data.
%   [Y,R,NEWID] = SIMDETECTPNT(LMKIDS,RAW,PIXCOV) return the coordinates Y,
%   the covariance R and the new id NEWID of the new point, based on the
%   simulation data.
%
%   See also INITNEWLMK, SIMDETECTLIN.

%   Copyright 2009 David Marquez @ LAAS-CNRS.

apps  = raw.points.app;

[newIds,newIdsIdx] = setdiff(apps,lmkIds);

visPnts = inSquare(...
    raw.points.coord(:,newIdsIdx),   ...
    [0 imSize(1) 0 imSize(2)], ...
    imSize(1)/25);

newIds(~visPnts)    = [];
newIdsIdx(~visPnts) = [];

if ~isempty(newIds)
    newId    = newIds(1);
    newIdx   = newIdsIdx(1);

    % best new point coordinates and covariance
    meas.y = raw.points.coord(:,newIdx);
    meas.R = pixCov;
    exp.e  = meas.y;
    exp.E  = meas.R;
    inn.z  = [0;0];
    inn.Z  = meas.R;

else

    newId  = [];
    meas.y = [];
    meas.R = [];
    exp.e  = [];
    exp.E  = [];
    inn.z  = [];
    inn.Z  = [];
end











