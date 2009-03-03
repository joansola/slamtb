function Ray = initRay(Ray,pix,dmin,dmax,a,b,g,t,ps)

% INITRAY  Initialize ray parameters
%   RAY = INITRAY(RAY,PIX,DMIN,DMAX,A,B,G,T,PS) initializes all 
%   necessary information in RAY structure.
%     Input RAY may be an empty ray feom EMPTYRAY()
%     PIX is the pixel at which it is defined
%     

global BDIM PDIM WDIM %Image

% parameters
Ray       = geomRay([dmin;dmax],a,b);
Ray.gamma = g; 
Ray.tau   = t;  

% variables
Ray.used = true; % ray is now used
Ray.id  = 0; % Landmark identifier
Ray.sig = pix2patch(pix,ps); % Patch 

Ray.n   = Ray.Ng; % Current nbr of points

Ray.loc = zeros(Ray.Ng,1); % points locations in map
Ray.w   = zeros(Ray.Ng,1); % weights

Ray.li  = zeros(Ray.Ng,1); % likelihoods
Ray.MD  = zeros(Ray.Ng,1); % Mahalanobis distances

Ray.ye  = zeros(BDIM,Ray.Ng); % expectation
Ray.z   = zeros(BDIM,Ray.Ng); % innovation
Ray.Z   = zeros(BDIM,BDIM,Ray.Ng); % inn. covariance
Ray.iZ  = zeros(BDIM,BDIM,Ray.Ng); % inn. inv. covariance

Ray.Hr  = zeros(BDIM,PDIM,Ray.Ng); % Jac wrt robot
Ray.Hc  = zeros(BDIM,CDIM,Ray.Ng); % Jac wrt camera
Ray.Hp  = zeros(BDIM,WDIM,Ray.Ng); % Jac wrt landmark


