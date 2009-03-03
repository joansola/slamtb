function Ray = pruneRay(Ray)

% PRUNERAY  Prune low weighted ray points
%   RAY = PRUNERAY(RAY) deletes unlikely points
%   from  RAY.
%
%   RAY is a structure containing:
%     w:   point weights
%     loc: point locations in map
%     n:   number of points
%     Ng:  maximum nomber of points per ray
%     tau: pruning threshold
%     pruned: locations of pruned points


% points to keep
keep = find(Ray.w(1:Ray.n) >= Ray.tau/Ray.Ng); % in ray

pruned = 1:Ray.n;
pruned(keep)=[];

Ray.pruned      = Ray.loc(pruned);

% ray parameters after pruning
Ray.n           = length(keep);
new = 1:Ray.n;
Ray.loc(new)    = Ray.loc(keep);
Ray.w(new)      = Ray.w(keep);

Ray.li(new)     = Ray.li(keep);
Ray.MD(new)     = Ray.MD(keep);

Ray.u(:,new)    = Ray.u(:,keep);
Ray.U(:,:,new)  = Ray.U(:,:,keep);
Ray.dU(new)     = Ray.dU(keep);

Ray.z(:,new)    = Ray.z(:,keep);
Ray.Z(:,:,new)  = Ray.Z(:,:,keep);
Ray.iZ(:,:,new) = Ray.iZ(:,:,keep);

Ray.Hr(:,:,new) = Ray.Hr(:,:,keep);
Ray.Hp(:,:,new) = Ray.Hp(:,:,keep);



