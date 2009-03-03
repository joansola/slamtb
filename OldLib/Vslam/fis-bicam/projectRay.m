function Ray = projectRay(Rob,Cam,Ray,R)
%
% PROJECTRAY  Project Ray into image plane
%   RAY = PROJECTRAY(ROB,CAM,RAY,OBS) projects the ray RAY into
%   the image plane of a camera CAM mounted on a robot ROB, using
%   the global map Map and the observation's noise covariances
%   matrix R.
%   Output is given by updating the fields of the input
%   structure RAY:
%     RAY.u(:,i)   is the projection of the mean of ray member i.
%     RAY.U(:,:,i) is the covariances matrix of this projection.
%     RAY.dU(i)    is the determinant of this covariance.
%     RAY.dUmax    is the maximum of all RAY.dU values.
%
%   See also INITRAY, RAYLIKELIHOOD, ISINRAY, PROJECTPNT

global Map Image WDIM CDIM

% get robot things
rr   = Rob.r; % robot range

% get camera things
cr   = Cam.r; % camera range
cor  = Cam.or; % camera range in its own frame vector
cid  = Cam.id; % camera identifier
isze = Cam.imSize; % Image size in hrizontal and vertical notation

% get ray things
mrg  = size(Ray.sig.I,1); % margin
n    = Ray.n;

% mean of 3d positions
p0  = zeros(WDIM,Ray.n); 

for i = 1:Ray.n

    % get point
    pr = loc2range(Ray.loc(i)); % point range
    p = Map.X(pr); % point

    % robot, camera and point range
    rcpr = [rr cr pr];

    % get robot, camera and point covariances
    P = Map.P(rcpr,rcpr);

    % projections
    [u,s,f] = robCamPhoto(Rob,Cam,p); % projection of mean

    % jacobians
    [Hr,Hc,Hp] = robCamPhotoJac(Rob,Cam,p);
    
    Hc = Hc(:,cor); % only orientation
    H  = [Hr Hc Hp]; % full rob, cam and pnt Jacobian

    U = H*P*H';    % projection of covariances matrix

    % Size of projected ellipse, total uncertainty of expectation
    dU = det(U);

    % get visible means
    inIm = inSquare(u,[0 isze(1) 0 isze(2)],mrg);
    vis = inIm & f;


    % Store all info for later use
    Ray.Prj(cid).Hr(:,:,i) = Hr;
    Ray.Prj(cid).Hc(:,:,i) = Hc;
    Ray.Prj(cid).Hp(:,:,i) = Hp;
    Ray.Prj(cid).u(:,i)    = u;
    Ray.Prj(cid).U(:,:,i)  = U;
    Ray.Prj(cid).Z(:,:,i)  = U+R; 
    Ray.Prj(cid).dU(i)     = dU;
    Ray.Prj(cid).s(i)      = s;
    Ray.Prj(cid).front(i)  = f;
    Ray.Prj(cid).vis(i)    = vis;

    % ray's 3d mean
    p0(:,i) = p; 
end

w    = Ray.w(1:n);
u    = Ray.Prj(cid).u(:,1:n);
wsum = sum(w);    % sum of weights

Ray.Prj(cid).dUmax = max(Ray.Prj(cid).dU(find(Ray.Prj(cid).front(1:n)))); % biggest ellipse
Ray.Prj(cid).u0 = u*w'/wsum; % weighted sum of means


% ray visible in this projection: all members must be visible.
Ray.Prj(cid).vis0 = any(Ray.Prj(cid).vis);

% initial and current estimated depths
p0     = p0*w'/wsum; % weighted sum of 3d positions

[u,si] = robCamPhoto(Ray.Robi,Cam,p0);
[u,s]  = robCamPhoto(Rob,Cam,p0);

Ray.Prj(cid).sr = s/si; % depths ratio

