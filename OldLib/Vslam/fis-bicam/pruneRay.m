function Ray = pruneRay(Ray)

% PRUNERAY  Prune low weighted ray points
%   RAY = PRUNERAY(RAY) deletes unlikely points from RAY and
%   updates all relevant fields in RAY.
%
%   RAY is a structure containing at least:
%     w:   point weights
%     loc: point locations in map
%     n:   number of points
%     Ng:  maximum nomber of points per ray
%     tau: pruning threshold
%     pruned: locations of pruned points
%
%   See also EMPTYRAY for a list of all fields in RAY.


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

for cam = 1:2
    if ~isempty(Ray.Prj(cam).li) % this projection contains useful data
        Ray.Prj(cam).li(new)     = Ray.Prj(cam).li(keep);
        Ray.Prj(cam).MD(new)     = Ray.Prj(cam).MD(keep);

        Ray.Prj(cam).u(:,new)    = Ray.Prj(cam).u(:,keep);
        Ray.Prj(cam).U(:,:,new)  = Ray.Prj(cam).U(:,:,keep);
        Ray.Prj(cam).dU(new)     = Ray.Prj(cam).dU(keep);

        Ray.Prj(cam).z(:,new)    = Ray.Prj(cam).z(:,keep);
        Ray.Prj(cam).Z(:,:,new)  = Ray.Prj(cam).Z(:,:,keep);
        Ray.Prj(cam).iZ(:,:,new) = Ray.Prj(cam).iZ(:,:,keep);

        Ray.Prj(cam).Hr(:,:,new) = Ray.Prj(cam).Hr(:,:,keep);
        Ray.Prj(cam).Hc(:,:,new) = Ray.Prj(cam).Hc(:,:,keep);
        Ray.Prj(cam).Hp(:,:,new) = Ray.Prj(cam).Hp(:,:,keep);
        
    else % this projection is empty
        Ray.Prj(cam).li = [];
        Ray.Prj(cam).MD = [];

        Ray.Prj(cam).u  = [];
        Ray.Prj(cam).U  = [];
        Ray.Prj(cam).dU = [];

        Ray.Prj(cam).z  = [];
        Ray.Prj(cam).Z  = [];
        Ray.Prj(cam).iZ = [];

        Ray.Prj(cam).Hr = [];
        Ray.Prj(cam).Hc = [];
        Ray.Prj(cam).Hp = [];
    end
end

