function drawEllipse(h,x,P,c,ns,NP)

% DRAWELLIPSE Draw 2D ellipse or 3D ellipsoid.
%   DRAWELLIPSE(H,X,P) redraws ellipse or ellipsoid in handle H with mean X
%   and covariance P.
%
%   DRAWELLIPSE(...,C) allows the specification of the ellipse color C.
%
%   drawellipse(...,C,ns,NP) allows entering the number of sigmas NS and
%   the number of points NP.

%   Copyright 2009 Joan Sola @ LAAS-CNRS.

if nargin < 6
    NP = 10;
    if nargin < 5
        ns = 3;
        if nargin < 4
            c = [];
        end
    end
end

if numel(x) == 2

    [X,Y] = cov2elli(x,P,ns,NP);
    if isempty(c)
        set(h,'xdata',X,'ydata',Y,'vis','on')
    else
        set(h,'xdata',X,'ydata',Y,'color',c,'vis','on')
    end
    
elseif numel(x) == 3
    
    [X,Y,Z] = cov3elli(x,P,ns,NP);
    if isempty(c)
        set(h,'xdata',X,'ydata',Y,'zdata',Z,'vis','on')
    else
        set(h,'xdata',X,'ydata',Y,'zdata',Z,'color',c,'vis','on')
    end
    
else
    
    error('??? Size of vector ''x'' not correct.')
    
end
