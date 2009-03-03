function Idp = idpFill(...
    Idp,...
    Rob,...
    Cam,...
    Obs,...
    Rho,...
    patchSize,...
    lostTh)

% IDPFILL  Idp fields filler.
%   IDP = IDPFILL(IDP,ROB,CAM,OBS,RHO,PATCHSIZE,LOSTIDPTH) fills all
%   appropiate fields in structure IDP, resulting from the inverse depth
%   initialization after an observation OBS from a camera CAM mounted on a
%   robot ROB. The ray is defined with a nominal inverse depth RHO. The descriptor
%   is a patch of size PATCHSIZExPATCHSIZE. A counter limit of match fails
%   for tracking purposes can be defined with LOSTIDPTH. Default ray
%   parameters are supported:
%       RHO       = 1
%       PATCHSIZE = 15
%       LOSTIDPTH = 5
%
%   Use IDPINIT to initialize the IDP into the Map.
%
%   See also INPINIT, LANDMARKINIT

global Image Map WDIM PDIM CDIM BDIM


% set defaults
if nargin < 7
    lostTh = 5;
    if nargin < 6
        patchSize = 15;
        if nargin < 5
            sMin = 1;
            if nargin < 4
                error('Not enough input arguments.')
            end
        end
    end
end

% usage
Idp.used = true;

% some constant matrices
z1Ng  = zeros(1,Ng);
zBBNg = zeros(BDIM,BDIM,Ng);
o1Ng  = ones(1,Ng);
cdim  = [0 CDIM];

% signature patch
Idp.sig    = pix2patch(Cam.id,Obs.y,patchSize); % Signature patch
Idp.wPatch = Idp.sig;           % Wrapped patch
Idp.Robi   = Rob; % Robot frame at first landmark detection

% observation and tracking things
Idp.vis     = 1;
Idp.dUmax   = 0;
Idp.matched = 1;
Idp.updated = 1;
Idp.lost    = 0;
Idp.lostTh  = lostTh;

% Camera dependent
for cam = 1:2

    if cam == Cam.id

        % depths things
        n = 1:Idp.Ng;
        s1 = sMin/(1-a);

        Idp.Prj(cam).Hr      = zeros(BDIM,PDIM,Ng); % Jacobian wrt robot frame
        Idp.Prj(cam).Hc      = zeros(BDIM,cdim(cam),Ng); % Jacobian wrt camera frame
        Idp.Prj(cam).Hp      = zeros(BDIM,WDIM,Ng); % Jacobian wrt point position

        Idp.Prj(cam).front   = o1Ng;  % True for positive depths
        Idp.Prj(cam).vis     = o1Ng;  % True for visible members of ray
        Idp.Prj(cam).vis0    = 1;     % True for visible rays
        Idp.Prj(cam).matched = 1;     % Idp matched
        Idp.Prj(cam).updated = 1;     % Idp updated
        Idp.Prj(cam).lost    = 0;     % Counter of not-found observations

        Idp.Prj(cam).y       = Obs.y; % measured pixel
        Idp.Prj(cam).s       = s1*b.^(n-1);  % Depths
        Idp.Prj(cam).s0      = mean(Idp.Prj(cam).s); % Weighted mean of depths
        Idp.Prj(cam).sr      = 1;     % estimated depths ratio (current to initial)
        Idp.Prj(cam).S       = (a*Idp.Prj(cam).s).^2;  % Depths variances

        for n = 1:Ng
            Dpt.s        = Idp.Prj(cam).s(n);
            Dpt.S        = Idp.Prj(cam).S(n);
            Lmk          = landmarkInit(Rob,Cam,Obs,Dpt);
            Idp.loc(n)   = Lmk.loc; % location of the point
            Idp.Prj(cam).u(:,n)   = Obs.y; % Projection or expectation
            Idp.Prj(cam).U(:,:,n) = Obs.R; % Projection's covariances matrices
            Idp.Prj(cam).Z(:,:,n) = Obs.R; % Innovation's covariances matrix
        end

        Idp.Prj(cam).u0      = Obs.y; % Weighted mean of all projections
        Idp.Prj(cam).dU      = z1Ng;  % Projection's covariance determinant
        Idp.Prj(cam).dUmax   = 0;     % Maximum determinant from above
        Idp.Prj(cam).z       = zBNg;  % Innovation
        Idp.Prj(cam).iZ      = zBBNg; % Inverse of innovation's covariance
        Idp.Prj(cam).MD      = z1Ng;  % Mahalanobis distances
        Idp.Prj(cam).li      = z1Ng;  % Likelihoods

        Idp.Prj(cam).region  = [];    % Parallelogram region for patch scan
        Idp.Prj(cam).cPatch  = Idp.sig; % Current patch
        Idp.Prj(cam).sc      = 1;       % score


    else

        Idp.Prj(cam).Hr      = zeros(BDIM,PDIM,Ng); % Jacobian wrt robot frame
        Idp.Prj(cam).Hc      = zeros(BDIM,cdim(cam),Ng); % Jacobian wrt camera frame
        Idp.Prj(cam).Hp      = zeros(BDIM,WDIM,Ng); % Jacobian wrt point position

        Idp.Prj(cam).front   = z1Ng;  % True for positive depths
        Idp.Prj(cam).vis     = z1Ng;  % True for visible members of ray
        Idp.Prj(cam).vis0    = 0;     % True for visible rays
        Idp.Prj(cam).matched = 0;     % Idp matched
        Idp.Prj(cam).updated = 0;     % Idp updated
        Idp.Prj(cam).lost    = 0;     % Counter of not-found observations

        Idp.Prj(cam).y       = zeros(BDIM,1); % measured pixel
        Idp.Prj(cam).s       = z1Ng;  % Depths
        Idp.Prj(cam).s0      = 0;     % Weighted mean of depths
        Idp.Prj(cam).sr      = 1;     % estimated depths ratio (current to initial)
        Idp.Prj(cam).S       = z1Ng;  % Depths variances
        Idp.Prj(cam).u       = zBNg;  % Projection or expectation
        Idp.Prj(cam).u0      = zeros(BDIM,1); % Weighted mean of all projections
        Idp.Prj(cam).U       = zBBNg; % Projection's covariances matrices
        Idp.Prj(cam).dU      = z1Ng;  % Projection's covariance determinant
        Idp.Prj(cam).dUmax   = 0;     % Maximum determinant from above
        Idp.Prj(cam).z       = zBNg;  % Innovation
        Idp.Prj(cam).Z       = zBBNg; % Innovation's covariances matrix
        Idp.Prj(cam).iZ      = zBBNg; % Inverse of innovation's covariance
        Idp.Prj(cam).MD      = z1Ng;  % Mahalanobis distances
        Idp.Prj(cam).li      = z1Ng;  % Likelihoods

        Idp.Prj(cam).region  = [];    % Parallelogram region for patch scan
        Idp.Prj(cam).cPatch  = [];    % Current  detected patch
        Idp.Prj(cam).sc      = -1;    % correlation score

    end
end


