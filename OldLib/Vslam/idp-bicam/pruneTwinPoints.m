function Ray = pruneTwinPoints(Ray)

% PRUNETWINPOINTS  Prune coincident ray points
%   RAY = PRUNETWINPOINTS(RAY) marks the weakest twin point for
%   pruning. For a two-points ray, twin points are those with
%   depths ratio less than 110%, this is:
%
%      Ray.Prj(1).s(2)/Ray.Prj(1).s(1) < 1.1 => prune the weakest


if Ray.n == 2  % change to >1 to check all ray

    if Ray.Prj(1).s(2)/Ray.Prj(1).s(1) < 1.2  % Keep only the best

        % point to keep
        keep = find(Ray.w(1:Ray.n) == max(Ray.w(1:Ray.n)));

        % points to prune
        prune = Ray.loc(1:Ray.n);
        prune(keep) = [];

        % Ray params after pruning
        Ray.n      = 1;
        Ray.loc(1) = Ray.loc(keep);
        Ray.pruned = [Ray.pruned;prune];

        for cam = 1:2
            if ~isempty(Ray.Prj(cam).li) % this projection contains useful data
                Ray.Prj(cam).li(1)     = Ray.Prj(cam).li(keep);
                Ray.Prj(cam).MD(1)     = Ray.Prj(cam).MD(keep);

                Ray.Prj(cam).u(:,1)    = Ray.Prj(cam).u(:,keep);
                Ray.Prj(cam).U(:,:,1)  = Ray.Prj(cam).U(:,:,keep);
                Ray.Prj(cam).dU(1)     = Ray.Prj(cam).dU(keep);

                Ray.Prj(cam).z(:,1)    = Ray.Prj(cam).z(:,keep);
                Ray.Prj(cam).Z(:,:,1)  = Ray.Prj(cam).Z(:,:,keep);
                Ray.Prj(cam).iZ(:,:,1) = Ray.Prj(cam).iZ(:,:,keep);

                Ray.Prj(cam).Hr(:,:,1) = Ray.Prj(cam).Hr(:,:,keep);
                Ray.Prj(cam).Hc(:,:,1) = Ray.Prj(cam).Hc(:,:,keep);
                Ray.Prj(cam).Hp(:,:,1) = Ray.Prj(cam).Hp(:,:,keep);

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

    end
end


