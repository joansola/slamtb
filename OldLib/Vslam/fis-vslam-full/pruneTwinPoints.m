function Ray = pruneTwinPoints(Ray)

% PRUNETWINPOINTS  Prune coincident ray points
%   RAY = PRUNETWINPOINTS(RAY) marks the weakest twin point for
%   pruning. For a two-points ray, twin points are those with 
%   depths ratio less than 110%, this is:
%
%      Ray.s(2)/Ray.s(1) < 1.1 => prune the weakest


if Ray.n == 2  % change to >1 to check all ray

    if Ray.s(2)/Ray.s(1) < 1.2  % Keep only the best

        % point to keep
        keep = find(Ray.w(1:Ray.n) == max(Ray.w(1:Ray.n))); 
        
        % points to prune
        prune = Ray.loc(1:Ray.n);
        prune(keep) = [];
        
        % Ray params after pruning
        Ray.n      = 1;
        Ray.loc(1) = Ray.loc(keep);
        Ray.pruned = [Ray.pruned;prune];
        
        Ray.s(:,1)    = Ray.s(:,keep);
        Ray.u(:,1)    = Ray.u(:,keep);
        Ray.U(:,:,1)  = Ray.U(:,:,keep);
        Ray.dU(:,1)   = Ray.dU(:,keep);
        
        Ray.z(:,1)    = Ray.z(:,keep);
        Ray.Z(:,:,1)  = Ray.Z(:,:,keep);
        Ray.iZ(:,:,1) = Ray.iZ(:,:,keep);
        
        Ray.Hr(:,:,1) = Ray.Hr(:,:,keep);
        Ray.Hp(:,:,1) = Ray.Hp(:,:,keep);
    end
end


