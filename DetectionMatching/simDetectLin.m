function [newId, meas, exp, inn] = simDetectLin(lmkIds, raw, pixCov)

apps  = raw.segments.app;

[newIds,newIdsIdx] = setdiff(apps,lmkIds);

% visLines = inSquare(...
%     raw.points.coord(:,newIdsIdx),   ...
%     [0 imSize(1) 0 imSize(2)], ...
%     imSize(1)/20);
%
% newIds(~visLines)    = [];
% newIdsIdx(~visLines) = [];

if ~isempty(newIds)
    newId    = newIds(1);
    newIdx   = newIdsIdx(1);

    % best new point coordinates and covariance
    y        = raw.segments.coord(:,newIdx);
    R        = blkdiag(pixCov,pixCov);

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


