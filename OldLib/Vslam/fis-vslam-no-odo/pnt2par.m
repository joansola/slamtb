function [par,Pnt] = pnt2par(Pnt,ns,imId,m)

% PNT2PAR  Parallelogram parameters of a projected point.
%   PNT2PAR(PNT,NS) computes the parallelogram containing 
%   the NS-sigma bound ellipse of the [projected] point PNT. 
%   The result is returned in a structure with all parameters.
%
%   [PAR,PNT] = PNT2PAR(...) returns the previous structure in
%   PAR and includes an exact copy in the PNT structure.
%
%   [...] = PNT2PAR(...,IMID,MARG) restrict the computed
%   parallelograme region so that it is inside the global image
%   Image{IMID} reduced at the edges by a margin MARG. If no
%   reduction is desired, set MARG = 0.
%
%   See also PROJECTPNT, and COV2PAR for information about the 
%   parallelogram region parameters.

global Image

% projected Gaussian
u = Pnt.u; % mean
U = Pnt.U; % cov matrix

% extreme parallelogrames
par = cov2par(u,U,ns); % first term

% restrict to image size minus margin
if nargin == 4
    imsze = rc2hv(size(Image{imId}));
    imszex = imsze(1);
    imszey = imsze(2);
    par.XM = min(par.XM,imszex-m-par.x0(1));
    par.Xm = max(par.Xm,m-par.x0(1));
    par.YM = min(par.YM,imszey-m-par.x0(2));
    par.Ym = max(par.Ym,m-par.x0(2));
    
    % assure origin is inside new bounds
    if ~inSquare(u,[0 imszex 0 imszey],m)
        u = max(u,[m;m]);
        u = min(u,imsze'-m);
        par.x0 = u;
    end
end

% Point structure
if nargout == 2
    Pnt.par = par;
end

