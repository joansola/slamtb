function par = cov2par(x,P,ns)

% COV2PAR  Covariances to parallelogram region. 
%   PAR = COV2PAR(X,P,NS) returns the bounding parameters of 
%   the NS-sigma bound elliptic region defined by the covariances
%   matrix P and centered at point X.
%   Computed parameters are returned as fields of the 
%   output structure PAR:
%   
%   .x0: position of origin (PAR.x0 = X input argument)
%   .xa: positive crossing point with x-axis
%   .ya: positive crossing point with y-axis
%   .XM: maximum x-coordinate
%   .Xm: minimum x-coordinate
%   .YM: maximum y-coordinate
%   .Xm: minimum y-coordinate
%   .mx: slope of the line: 
%           y = mx*x
%        joining the two points at y=Ym and y=YM
%   .my: slope of the line:
%           x = my*y
%        joining the two points at x=Xm and x=XM
%
%   All fields except .x0 are expressed with respect to .x0

% correlations
Cxx = P(1,1);
Cxy = P(1,2);
Cyy = P(2,2);

% bounds
par.XM =  ns*sqrt(Cxx);
par.Xm = -ns*sqrt(Cxx);
par.YM =  ns*sqrt(Cyy);
par.Ym = -ns*sqrt(Cyy);

% center
par.x0 = x;

% parallelograme
par.mx = Cxy/Cxx;
par.my = Cxy/Cyy;

par.xa = ns/Cyy*(-Cyy*(-Cxx*Cyy+Cxy^2))^(1/2);
par.ya = ns/Cxx*(Cxx*(Cxx*Cyy-Cxy^2))^(1/2);

return

%%
syms Cxx Cyy Cxy sx sy sxy x y real
P = [sx^2 Cxy;Cxy sy^2];
% P = [Cxx Cxy;Cxy Cyy];

%% 1. find points x when y = sy
X = [x;sy];

% ellipse
E = X'*P^-1*X;

xM = solve(E-1,'x');

my = simplify(xM(1)/sy)

%% 2. find points y when x = sx;
X = [sx;y];
E = X'*P^-1*X;

yM = solve(E-1,'y');

mx = simplify(yM(1)/sx)

%% 3. find y when x = 0
X = [0;y];

% ellipse
E = X'*P^-1*X;

ya = solve(E-1,'y')

%% 4. find x when y=0
X = [x;0];
E = X'*P^-1*X;
xa = solve(E-1,'x')


