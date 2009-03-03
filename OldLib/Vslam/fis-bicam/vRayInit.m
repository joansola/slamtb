function vRay = vRayInit(...
    Cam,...
    Obs,...
    sMin,sMax,...
    a,...
    patchSize)

% VRAYINIT  Virtual ray initialization
%   VRAY = VRAYINIT(CAM,OBS,SMIN,SMAX) fills all appropiate
%   fields in structure VRAY, resulting from the initialization
%   after an observation OBS from a camera CAM mounted on a robot
%   ROB. The ray is defined with two Gaussians at depths
%   SMIN and SMAX.
%
%   RAY = RAYINIT(...,ALPHA,PSIZE) permits the specification of
%   parameter ALPHA and patch size PSIZE. Their default values
%   are:
%     {ALPHA,PSIZE} = {0.3,15}
%
%   See also RAYINIT

global Map


% set defaults
if nargin < 7
    patchSize = 15;
    if nargin < 6
        a = 0.3;
        if nargin < 5
            error('Not enough input arguments.')
        end
    end
end

% vRay things
vRay.Ng   = 2;
vRay.n    = 2;
vRay.used = 1;

% Observation things
y = Obs.y;
R = Obs.R;

% signature patch
vRay.sig    = pix2patch(1,y,patchSize); % Signature patch
vRay.wPatch = vRay.sig;           % Wrapped patch

% depth things
s = [sMin/(1-a) sMax];
S = (a*s).^2;

for n = 1:2 % just 2 points, very near and very far
    
    % In camera 1
    vRay.Prj(1).y        = y;
    vRay.Prj(1).u(:,n)   = y;
    vRay.Prj(1).U(:,:,n) = zeros(2);
    vRay.Prj(1).Z(:,:,n) = R;
    vRay.Prj(1).matched  = 1;
    vRay.Prj(1).updated  = 1;
    
    % 3D Points in robot frame
    p          = invCamPhoto(Cam(1),y,s(n));
    [Gc,Gw,Gs] = invCamPhotoJac(Cam(1),y,s(n));
    P          = Gw*R*Gw' + Gs*S(n)*Gs';
    
    % Projection onto camera 2
    u          = camPhoto(Cam(2),p);
    [Hc,Hp]    = camPhotoJac(Cam(2),p);
    Hc         = Hc(:,Cam(2).or);
    Pc         = Map.P(Cam(2).r,Cam(2).r);
    Up         = Hp*P*Hp';
    Uc         = Hc*Pc*Hc';
    U          = Uc + Up;

    % Results
    vRay.Prj(2).u(:,n)    = u;     % Projection or expectation
    vRay.Prj(2).U(:,:,n)  = U;     % Expectation's covariances matrices
    vRay.Prj(2).Up(:,:,n) = Up;    % Point's covariances matrices
    vRay.Prj(2).Uc(:,:,n) = Uc;    % Calibration's covariances matrices
    vRay.Prj(2).Z(:,:,n)  = U + R; % Innovation covariance
    
end

vRay.Prj(2).u0 = mean(vRay.Prj(2).u')';  % center of region


