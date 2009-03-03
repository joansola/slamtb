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
u = Pnt.Prj(imId).u; % mean
Z = Pnt.Prj(imId).Z; % cov matrix

% extreme parallelogrames
par = cov2par(u,Z,ns); % first term

% restrict to image size minus margin
if nargin == 4
    imsze = rc2hv(size(Image{imId}));
    imszex = imsze(1);
    imszey = imsze(2);
    par.XM = min(par.XM,imszex-m-par.x0(1));
    par.Xm = max(par.Xm,m-par.x0(1));
    par.YM = min(par.YM,imszey-m-par.x0(2));
    par.Ym = max(par.Ym,m-par.x0(2));
    
    % assure params are inside reduced image bounds
    % center
%     if ~inSquare(u,[0 imszex 0 imszey],m)
%         u = max(u,[m;m]);
%         u = min(u,imsze'-m);
%         par.x0 = u;
%     end
    ULcorner = par.x0+[par.Xm;par.Ym];
    if ~inSquare(ULcorner,[0 imszex 0 imszey],m)
        ULcorner = max(ULcorner,[m;m]);
        ULcorner = min(ULcorner,imsze'-m);
        par.Xm = ULcorner(1)-par.x0(1);
        par.Ym = ULcorner(2)-par.x0(2);
    end
    LRcorner = par.x0+[par.XM;par.YM];
    if ~inSquare(LRcorner,[0 imszex 0 imszey],m)
        LRcorner = max(LRcorner,[m;m]);
        LRcorner = min(LRcorner,imsze'-m);
        par.XM = LRcorner(1)-par.x0(1);
        par.YM = LRcorner(2)-par.x0(2);
    end
    if (par.XM < 0) || (par.YM < 0)
        
        X0 = (par.Xm + par.XM)/2;
        Y0 = (par.Ym + par.YM)/2;
        par.x0 = par.x0 + [X0;Y0];
        par.Xm = par.Xm-X0;
        par.XM = par.XM-X0;
        par.Ym = par.Ym-Y0;
        par.YM = par.YM-Y0;
        par.mx = 0;
        par.my = 0;
        par.xa = par.XM;
        par.ya = par.YM;
    end
    
    
    
end

% Point structure
if nargout == 2
    Pnt.Prj(imId).region = par;
end

