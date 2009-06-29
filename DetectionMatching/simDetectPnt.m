function [y,R,newId] = simDetectPnt(lmkIds, raw, pixCov, imSize)

%SIMDETECTPNT Detect 2D point in simulated Raw data.
%   [Y,R,NEWID] = SIMDETECTPNT(LMKIDS,RAW,PIXCOV) return the coordinates Y,
%   the covariance R and the new id NEWID of the new point, based on the
%   simulation data.
%
%   See also INITNEWLMK, SIMDETECTLIN.

%   (c) 2009 DavidMarquez @ LAAS-CNRS.

apps  = raw.points.app;

[newIds,newIdsIdx] = setdiff(apps,lmkIds);

visPnts = inSquare(...
    raw.points.coord(:,newIdsIdx),   ...
    [0 imSize(1) 0 imSize(2)], ...
    imSize(1)/20);

newIds(~visPnts)    = [];
newIdsIdx(~visPnts) = [];

if ~isempty(newIds)
    newId    = newIds(1);
    newIdx   = newIdsIdx(1);
    
    % best new point coordinates and covariance
    y        = raw.points.coord(:,newIdx);
    R        = pixCov;
    
else
    
    newId = [];
    y     = [];
    R     = [];
    
end


