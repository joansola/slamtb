function [y,R,newId] = simDetectFeature(lmkIds, raw, pixCov)

%SIMDETECTFEATURE Detected feature.
%   [Y,R,NEWID] = SIMDETECTFEATURE(LMKIDS,RAW,PIXCOV) return the
%   coordinates Y, the covariance R and the new id NEWID of the new point,
%   based on the simulation data.
%
%   See also INITNEWLMK.

%   (c) 2009 DavidMarquez @ LAAS-CNRS.



[newIds,newIdsIdx] = setdiff(raw.appearance,lmkIds);

if ~isempty(newIds)
    newId    = newIds(1);
    newIdx   = newIdsIdx(1);
    
    % bet new point coordinates and covariance
    y        = raw.points(:,newIdx);
    R        = pixCov;
    
else
    
    newId = [];
    y     = [];
    R     = [];
    
end


