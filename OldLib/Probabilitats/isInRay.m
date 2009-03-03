function ins = isInRay(x,Ray,ns)

% ISINRAY Check if point is inside a ray of ellipses
%   ISINRAY(X,RAY,NS) is true if X is inside of at least
%   one of the NS-sigma bound projected ellipses of the ray RAY.
%
%   See also ISINSIDE, RAYINIT, RAYLIKELIHOOD

global Map

insi = zeros(1,Ray.n);
for i = 1:Ray.n
    xm = Ray.u(:,i); % Mean of projected ellipses
    P  = Ray.U(:,:,i); % Covariances of projected ellipses
    insi(i) = isInElli(x,xm,P,ns);
end

ins = any(insi); % true if x is inside any ellipse
