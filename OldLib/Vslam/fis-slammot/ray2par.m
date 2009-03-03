function [par,Ray] = ray2par(Ray,prj,ns,m)

% RAY2PAR  Parallelogram parameters of a projected ray.
%   RAY2PAR(RAY,PRJ,NS) computes the parallelogram containing all
%   the NS-sigma bound ellipses of the [projected] ray RAY(PRJ). 
%   The result is returned in a structure with all parameters.
%
%   [PAR,RAY] = RAY2PAR(...) returns the previous structure in
%   PAR and includes an exact copy in the RAY.Prj(PRJ).region
%   field.
%
%   [...] = RAY2PAR(...,MARG) restrict the computed
%   parallelograme region so that it is inside the global image
%   Image{PRJ} reduced at the edges by a margin MARG. If no
%   reduction is desired, set MARG = 0.
%
%   See also PROJECTRAY, and COV2PAR for information about the 
%   parallelogram region parameters.

global Image

% general ray properties
n = Ray.n; % number of terms

% projected Gaussians
u = Ray.Prj(prj).u(:,1:n); % mean
Z = Ray.Prj(prj).Z(:,:,1:n); % cov matrix

% extreme Gaussians
u1 = u(:,1);
Z1 = Z(:,:,1);
un = u(:,n);
Zn = Z(:,:,n);

% origin of region = weighted mean of term's means
u0 = Ray.Prj(prj).u0;

% relative to region's origin
u1 = u1-u0; % means relative to region origin
un = un-u0;

% extreme parallelogrames
par1 = cov2par([0;0],Z1,ns); % first term
parn = cov2par([0;0],Zn,ns); % last term

% bounding box
XM = max(u1(1)+par1.XM,un(1)+parn.XM); % bounding box
Xm = min(u1(1)+par1.Xm,un(1)+parn.Xm);
YM = max(u1(2)+par1.YM,un(2)+parn.YM);
Ym = min(u1(2)+par1.Ym,un(2)+parn.Ym);

% restrict to image size minus margin
if nargin == 4 
    imsze  = rc2hv(size(Image{prj}));
    imszex = imsze(1);
    imszey = imsze(2);
    XM = min(XM,imszex-m-u0(1));
    Xm = max(Xm,m-u0(1));
    YM = min(YM,imszey-m-u0(2));
    Ym = max(Ym,m-u0(2));
    
    ULcorner = u0+[Xm;Ym];
    if ~inSquare(ULcorner,[0 imszex 0 imszey],m)
        ULcorner = max(ULcorner,[m;m]);
        ULcorner = min(ULcorner,imsze'-m);
        Xm = ULcorner(1)-u0(1);
        Ym = ULcorner(2)-u0(2);
    end
    LRcorner = u0+[XM;YM];
    if ~inSquare(LRcorner,[0 imszex 0 imszey],m)
        LRcorner = max(LRcorner,[m;m]);
        LRcorner = min(LRcorner,imsze'-m);
        XM = LRcorner(1)-u0(1);
        YM = LRcorner(2)-u0(2);
    end

end

% obliquous bound slope
du = un-u1; % ray directrice
mx = du(2)/(du(1)+eps); % slope if y = xa + mx*x
my = du(1)/(du(2)+eps); % slope if x = ya + my*y

% bounding parallelograme
[R,D] = svd(Z1);
rho = ns*sqrt(D(2,2)); % small semiaxis
xa = abs(rho/(R(2,1)+eps));
ya = abs(rho/(R(1,1)+eps));

par.x0 = u0; % Starting point or region origin
par.mx = mx; % Slope of y = mx*(x-xa)
par.my = my; % Slope of x = my*(y-ya)
par.xa = xa; % positive crossing with x axis in x0 frame
par.ya = ya; % positive crossing with y axis in x0 frame
par.XM = XM; % max x-limit in x0 frame
par.Xm = Xm; % min x-limit in x0 frame
par.YM = YM; % max y-limit in x0 frame
par.Ym = Ym; % min y-limit in x0 frame

if nargout == 2
    Ray.Prj(prj).region = par;
end


