function [y,R, newId] = simDetectFeature(lmkIds, raw, pixCov)



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


