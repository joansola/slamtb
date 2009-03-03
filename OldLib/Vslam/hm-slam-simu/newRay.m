function R = newRay(R,id,smin,smax,a,b,g,t,lostTh,scLgth)

% NEWRAY  Create new ray
%   R = NEWRAY(R,ID,SMIN,SMAX,A,B,G,T) fills appropiate 
%   fields of ray R to accomodate a ray with parameters:
%     ID:   ray identifier
%     SMIN: minimum depth
%     SMAX: maximum depth
%     A:    aspect ratio 'alpha'
%     B:    geometric base 'beta'
%     G:    vanishing factor 'gamma'
%     T:    pruning threshold 'tau'
%
%   See also EMPTYRAY

%global Image

% usage
R.used = true;
R.id   = id;

% number of terms
R.Ng = 1+ceil(log(((1-a)/(1+a))*((smax)/(smin)))/log(b));
R.n  = R.Ng;

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

