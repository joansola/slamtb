function drawEllipse(h, x, P, c, ns, NP)

% DRAWELLIPSE Draw 2D ellipse or 3D ellipsoid.
%   DRAWELLIPSE(H,X,P) redraws ellipse or ellipsoid in handle H with mean X
%   and covariance P.
%
%   DRAWELLIPSE(...,C) allows the specification of the ellipse color C. If
%   C is not given or is empty, the color is unchanged.
%
%   DRAWELLIPSE(...,C,NS,NP) allows entering the number of sigmas NS and
%   the number of points NP. The default values are NS=3 and NP=10. Use
%   C=[] if you do not want to modify the ellipse color.

%   Copyright 2009 Joan Sola @ LAAS-CNRS.

if nargin < 6,         NP = 10;
    if nargin < 5,     ns = 3;
    end
end

if numel(x) == 2

    [X,Y] = cov2elli(x,P,ns,NP);
    set(h,'xdata',X,'ydata',Y,'vis','on')
    
elseif numel(x) == 3
    
    [X,Y,Z] = cov3elli(x,P,ns,NP);
    set(h,'xdata',X,'ydata',Y,'zdata',Z,'vis','on')
    
else
    error('??? Size of vector ''x'' not correct.')
end

if nargin > 3 && ~isempty(c)
    set(h,'color',c)
end








