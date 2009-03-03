function Ray = projectRay(Rob,Cam,Ray)
%
% PROJECTRAY  Project Ray into image plane
%   RAY = PROJECTRAY(ROB,CAM,RAY) projects the ray RAY
%   into the image plane of a camera CAM mounted on a
%   robot ROB, using the global map Map.
%   Output is given by updating the fields of the input
%   structure RAY:
%     RAY.u(:,i)   is the projection of the mean of ray member i.
%     RAY.U(:,:,i) is the covariances matrix of this projection.
%     RAY.dU(i)    is the determinant of this covariance.
%     RAY.dUmax    is the maximum of all RAY.dU values.
%
%   See also INITRAY, RAYLIKELIHOOD, ISINRAY, PROJECTPNT

global Map %Image WDIM CDIM

isze = Cam.imSize; % Image size in hrizontal and vertical notation
mrg = 10; % 10 pixels margin

% get robot things
rr = Rob.r; % robot range

% get camera things
cr = Cam.r; % camera range
cor = Cam.or; % camera range in its own frame vector

usum  = [0;0];   % weighted sum of means
psum  = [0;0;0]; % weighted sum of 3d positions
for i = 1:Ray.n

    % get point
    pr = loc2range(Ray.loc(i)); % point range
    p = Map.X(pr); % point

    % robot, camera and point range
    rpr = [rr cr pr];

    % get robot, camera and point covariances
    P = Map.P(rpr,rpr);

    % jacobians
    [Hr,Hc,Hp] = robCamPhotoJac(Rob,Cam,p);
    
    % projections
    [u,s,f] = robCamPhoto(Rob,Cam,p); % projection of mean

    Hc = Hc(:,cor); % only orientation
    H  = [Hr Hc Hp]; % full rob, cam and pnt Jacobian

    U = H*P*H';    % projection of covariances matrix

    % Size of projected ellipse, total uncertainty of expectation
    dU = det(U);

    % get visible means
    inIm = inSquare(u,[0 isze(1) 0 isze(2)],mrg);
    vis = inIm & f;


    % Store all info for later use
    Ray.Hr(:,:,i) = Hr;
    Ray.Hp(:,:,i) = Hp;
    Ray.u(:,i)    = u;
    Ray.U(:,:,i)  = U;
    Ray.dU(i)     = dU;
    Ray.s(i)      = s;
    Ray.front(i)  = f;
    Ray.vis(i)    = vis;

    % sum of weighted means
    w    = Ray.w(i);
    usum = usum + w*u; % ray's mean in image plane
    psum = psum + w*p; % ray's 3d mean
end

Ray.dUmax = max(Ray.dU(Ray.front)); % biggest ellipse
wsum      = sum(Ray.w(1:Ray.n));    % sum of weights
Ray.u0    = usum/wsum; % weighted sum of means
p0        = psum/wsum; % weighted sum of 3d positions

% get visible ray mean: all members must be visible.
Ray.vis0 = all(Ray.vis);

% initial and currend estimated depths
[u,si] = robCamPhoto(Ray.Robi,Cam,p0);
[u,s]  = robCamPhoto(Rob,Cam,p0);

% depths ratio
Ray.sr = s/si;
