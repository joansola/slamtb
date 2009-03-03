function Ray = rayInit(Rob,Cam,Obs,Ray)

% RAYINIT  Ray initialization
%   RAY = RAYINIT(ROB,CAM,OBS,RAY) initializes a ray RAY
%   in the global map Map from a bearing observation OBS
%   taken from a robot ROB with a camera CAM.
%
%   See also LANDMARKINIT


Ray.w = ones(1,Ray.Ng)/Ray.Ng;

for n = 1:Ray.Ng
    Dpt.s        = Ray.s(n);
    Dpt.S        = Ray.S(n);
    Lmk          = landmarkInit(Rob,Cam,Obs,Dpt);
    Ray.loc(n)   = Lmk.loc; % location of the point
    Ray.y        = Obs.y;
    Ray.u(:,n)   = Obs.y;
    Ray.U(:,:,n) = Obs.R;
end

Ray.u0 = Obs.y;

Ray.Robi = Rob; % Robot frame at first landmark detection

Ray.matched = 1;
Ray.updated = 1;
