function [y,R, newId] = SimdetectFeature(lmkIds, raw, cov)

[newIds,newIdsIdx] = setdiff(raw.ids,lmkIds);

if ~isempty(newIds)
    newId    = newIds(1);
    newIdx   = newIdsIdx(1);
    
    % bet new point coordinates and covariance
    y        = raw.points(:,newIdx);
    R        = cov.pixCov;
    
end


