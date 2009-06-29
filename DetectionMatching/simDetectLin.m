function [y, R, newId] = simDetectLin(lmkIds, raw, pixCov)

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
    
else
    
    newId = [];
    y     = [];
    R     = [];
    
end


