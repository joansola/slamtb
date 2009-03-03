function vRay = vRayInit(Cam,Obs,sMin,patchSize)

% VRAYINIT  Virtual ray initialization
%   VRAY = VRAYINIT(CAM,OBS,SMIN) fills all appropiate
%   fields in structure VRAY, resulting from the initialization
%   after an observation OBS from a camera CAM mounted on a robot
%   ROB. The ray is defined with an inverse depth Gaussian at SMIN minimum
%   distance. The default is SMIN = 1 m.
%
%   RAY = RAYINIT(...,PSIZE) permits the specification of
%   patch size PSIZE. Its default value is PSIZE = 15 pixels
%
%   See also RAYINIT

global Map


% set defaults
if nargin < 4
    patchSize = 15;
    if nargin < 3
        sMin = 1;
        if nargin < 2
            error('Not enough input arguments.')
        end
    end
end

% vRay things
vRay.used = 1;

% Observation things
y = Obs.y;
R = Obs.R;

% signature patch
vRay.sig    = pix2patch(1,y,patchSize); % Signature patch
vRay.wPatch = vRay.sig;           % Wrapped patch

% Inverse depth things. rho is inverse depth.
% We impose 1/(rho0-Srho) = infty => Srho = rho0 ;
%       and 1/(rho0+Srho) = sMin  => rho0 = 1/(2*sMin) .
vRay.rho  = 1/(2*sMin);    % nominal inverse depth
vRay.RHO  = rho0^2;        % inverse depth variance.
vRay.x0   = Cam(1).X(1:3); % Ray origin;
vRay.ang  = [];            % Ray direction angles

% In camera 1
vRay.Prj(1).y        = y;
vRay.Prj(1).u        = y;
vRay.Prj(1).U        = zeros(2);
vRay.Prj(1).Z        = R;
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
    
vRay.Prj(2).u0 = mean(vRay.Prj(2).u,2)';  % center of region


