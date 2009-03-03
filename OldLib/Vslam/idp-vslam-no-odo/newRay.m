function R = newRay(R,imId,p,ps,smin,smax,a,b,g,t,lostTh,scLgth)

% NEWRAY  Create new ray
%   R = NEWRAY(R,IMID,PIX,PS,SMIN,SMAX,A,B,G,T,LTH,SCL) fills appropiate 
%   fields of ray R to accomodate a ray with parameters:
%     SIG:  ray signature, PSxPS sized patch around PIX
%     SMIN: minimum depth
%     SMAX: maximum depth
%     A:    aspect ratio 'alpha'
%     B:    geometric base 'beta'
%     G:    vanishing factor 'gamma'
%     T:    pruning threshold 'tau'
%     LTH:  lost threshold 'lostTh'
%     SCL:  scores history length
%
%   IMID is an index identifying the image to crop the patch from
%   the global Image. this image is Image{IMID}
%
%   See also EMPTYRAY

%global Image

% usage
R.used = true;

% signature patch
R.sig    = pix2patch(imId,p,ps); % Signature patch
R.wPatch = R.sig;           % Wrapped patch
R.cPatch = R.sig;           % Current patch
R.sc     = 1;               % score

% number of terms
R.Ng = 1+ceil(log(((1-a)/(1+a))*((smax)/(smin)))/log(b));
R.n = R.Ng;

s1 = smin/(1-a);

n = 1:R.Ng;

% depths
R.s     = s1*b.^(n-1);
R.S     = (a*R.s).^2;
R.front = true(1,R.Ng);
R.vis   = true(1,R.Ng);
R.vis0  = true;

% other parameters
R.alpha  = a;
R.beta   = b;
R.gamma  = g;
R.tau    = t;
R.lost   = 0;
R.lostTh = lostTh;
R.scl    = scLgth;
R.scp    = 1;

