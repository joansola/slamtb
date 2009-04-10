function [y,R, newId] = simDetectFeature(lmkIds, raw, cov)



[newIds,newIdsIdx] = setdiff(raw.appearance,lmkIds);

if ~isempty(newIds)
    newId    = newIds(1);
    newIdx   = newIdsIdx(1);
    
    % bet new point coordinates and covariance
    y        = raw.points(:,newIdx);
    R        = cov.pixCov;
    
end


