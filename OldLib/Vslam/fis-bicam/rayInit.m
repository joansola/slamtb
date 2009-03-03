function Ray = rayInit(...
    Ray,...
    Rob,...
    Cam,...
    Obs,...
    sMin,sMax,...
    a,b,g,t,...
    patchSize,...
    lostTh)

% RAYINIT  Ray initialization
%   RAY = RAYINIT(RAY,ROB,CAM,OBS,SMIN,SMAX) fills all appropiate
%   fields in structure RAY, resulting from the initialization
%   after an observation OBS from a camera CAM mounted on a robot
%   ROB. The ray is defined between minimum and maximum depths
%   SMIN and SMAX. All other ray parameters are taken as default:
%     {ALPHA,BETA,GAMMA,TAU} = {0.3,3,0.2,0.01}
%     PATCHSIZE = 15
%     LOSTRAYTH = 5
%
%   RAY = RAYINIT(...,ALPHA,BETA,GAMMA,TAU,PATCHSIZE,LOSTRAYTH)
%   permits the specification of all above parameters. To choose
%   its default simply give it as [].
%
%   See also EMPTYRAY, LANDMARKINIT

global Image Map WDIM PDIM CDIM BDIM


% set defaults
if nargin < 12
    lostTh = 5;
    if nargin < 11
        patchSize = 15;
        if nargin < 10
            tau = 0.01;
            if nargin < 9
                gamma = 0.2;
                if nargin < 8
                    beta = 3;
                    if nargin < 7
                        alpha = 0.3
                        if nargin < 6
                            error('Not enough input arguments.')
                        end
                    end
                end
            end
        end
    end
end

% usage
Ray.used = true;

% number of terms
Ng     = numTerms(a,b,sMin,sMax);
Ray.Ng = Ng;
Ray.n  = Ng;

% some constant matrices
z1Ng  = zeros(1,Ng);
zNg1  = zeros(Ng,1);
zWNg  = zeros(WDIM,Ng);
zNgW  = zeros(Ng,WDIM);
zBNg  = zeros(BDIM,Ng);
zNgB  = zeros(Ng,BDIM);
zBBNg = zeros(BDIM,BDIM,Ng);
o1Ng  = ones(1,Ng);
cdim  = [0 CDIM];

% signature patch
Ray.sig    = pix2patch(Cam.id,Obs.y,patchSize); % Signature patch
Ray.wPatch = Ray.sig;           % Wrapped patch
Ray.Robi   = Rob; % Robot frame at first landmark detection

% other parameters
Ray.alpha  = a;
Ray.beta   = b;
Ray.gamma  = g;
Ray.tau    = t;

% weights
Ray.w = o1Ng/Ng;

% observation and tracking things
Ray.vis0    = 1;
Ray.dUmax   = 0;
Ray.matched = 1;
Ray.updated = 1;
Ray.lost    = 0;
Ray.lostTh  = lostTh;
Ray.pruned  = [];

% Camera dependent
for cam = 1:2

    if cam == Cam.id

        % depths things
        n = 1:Ray.Ng;
        s1 = sMin/(1-a);

        Ray.Prj(cam).Hr      = zeros(BDIM,PDIM,Ng); % Jacobian wrt robot frame
        Ray.Prj(cam).Hc      = zeros(BDIM,cdim(cam),Ng); % Jacobian wrt camera frame
        Ray.Prj(cam).Hp      = zeros(BDIM,WDIM,Ng); % Jacobian wrt point position

        Ray.Prj(cam).front   = o1Ng;  % True for positive depths
        Ray.Prj(cam).vis     = o1Ng;  % True for visible members of ray
        Ray.Prj(cam).vis0    = 1;     % True for visible rays
        Ray.Prj(cam).matched = 1;     % Ray matched
        Ray.Prj(cam).updated = 1;     % Ray updated
        Ray.Prj(cam).lost    = 0;     % Counter of not-found observations

        Ray.Prj(cam).y       = Obs.y; % measured pixel
        Ray.Prj(cam).s       = s1*b.^(n-1);  % Depths
        Ray.Prj(cam).s0      = mean(Ray.Prj(cam).s); % Weighted mean of depths
        Ray.Prj(cam).sr      = 1;     % estimated depths ratio (current to initial)
        Ray.Prj(cam).S       = (a*Ray.Prj(cam).s).^2;  % Depths variances

        for n = 1:Ng
            Dpt.s        = Ray.Prj(cam).s(n);
            Dpt.S        = Ray.Prj(cam).S(n);
            Lmk          = landmarkInit(Rob,Cam,Obs,Dpt);
            Ray.loc(n)   = Lmk.loc; % location of the point
            Ray.Prj(cam).u(:,n)   = Obs.y; % Projection or expectation
            Ray.Prj(cam).U(:,:,n) = Obs.R; % Projection's covariances matrices
            Ray.Prj(cam).Z(:,:,n) = Obs.R; % Innovation's covariances matrix
        end

        Ray.Prj(cam).u0      = Obs.y; % Weighted mean of all projections
        Ray.Prj(cam).dU      = z1Ng;  % Projection's covariance determinant
        Ray.Prj(cam).dUmax   = 0;     % Maximum determinant from above
        Ray.Prj(cam).z       = zBNg;  % Innovation
        Ray.Prj(cam).iZ      = zBBNg; % Inverse of innovation's covariance
        Ray.Prj(cam).MD      = z1Ng;  % Mahalanobis distances
        Ray.Prj(cam).li      = z1Ng;  % Likelihoods

        Ray.Prj(cam).region  = [];    % Parallelogram region for patch scan
        Ray.Prj(cam).cPatch  = Ray.sig; % Current patch
        Ray.Prj(cam).sc      = 1;       % score


    else

        Ray.Prj(cam).Hr      = zeros(BDIM,PDIM,Ng); % Jacobian wrt robot frame
        Ray.Prj(cam).Hc      = zeros(BDIM,cdim(cam),Ng); % Jacobian wrt camera frame
        Ray.Prj(cam).Hp      = zeros(BDIM,WDIM,Ng); % Jacobian wrt point position

        Ray.Prj(cam).front   = z1Ng;  % True for positive depths
        Ray.Prj(cam).vis     = z1Ng;  % True for visible members of ray
        Ray.Prj(cam).vis0    = 0;     % True for visible rays
        Ray.Prj(cam).matched = 0;     % Ray matched
        Ray.Prj(cam).updated = 0;     % Ray updated
        Ray.Prj(cam).lost    = 0;     % Counter of not-found observations

        Ray.Prj(cam).y       = zeros(BDIM,1); % measured pixel
        Ray.Prj(cam).s       = z1Ng;  % Depths
        Ray.Prj(cam).s0      = 0;     % Weighted mean of depths
        Ray.Prj(cam).sr      = 1;     % estimated depths ratio (current to initial)
        Ray.Prj(cam).S       = z1Ng;  % Depths variances
        Ray.Prj(cam).u       = zBNg;  % Projection or expectation
        Ray.Prj(cam).u0      = zeros(BDIM,1); % Weighted mean of all projections
        Ray.Prj(cam).U       = zBBNg; % Projection's covariances matrices
        Ray.Prj(cam).dU      = z1Ng;  % Projection's covariance determinant
        Ray.Prj(cam).dUmax   = 0;     % Maximum determinant from above
        Ray.Prj(cam).z       = zBNg;  % Innovation
        Ray.Prj(cam).Z       = zBBNg; % Innovation's covariances matrix
        Ray.Prj(cam).iZ      = zBBNg; % Inverse of innovation's covariance
        Ray.Prj(cam).MD      = z1Ng;  % Mahalanobis distances
        Ray.Prj(cam).li      = z1Ng;  % Likelihoods

        Ray.Prj(cam).region  = [];    % Parallelogram region for patch scan
        Ray.Prj(cam).cPatch  = [];    % Current  detected patch
        Ray.Prj(cam).sc      = -1;    % correlation score

    end
end


