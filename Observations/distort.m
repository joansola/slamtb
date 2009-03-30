function [ud,UDup,UDdist] = distort(up,dist,rmax)

% DISTORT  Distort projected point with radial distortion.
%   DISTORT(UP,DIST) computes the position in the image plane of the
%   distorted pixel corresponding to the projected pixel UP. DIST is the
%   vector of distortion parameters. Distortion is calculated with the
%   radial distortion model:
%
%     UD = UP * (1 + k2*r^2 + k4*r^4 + k6*r^6 + ...)
%
%   where r^2  = UP(1)^2 + UP(2)^2
%     and DIST = [k4 k4 k6 ...]
%
%   [ud,UDup,UDdist] = DISTORT(...) returns Jacobians wrt UP and DIST. Only
%   DIST vectors of up to order 3 are supported. If a higher order is
%   desired use a Jacobian builder at the bottom of DISTORT.M file (and
%   read the notes that come with it).
%

%   FIXME: RMAX works not so nice
%   DISTORT(...,RMAX) accepts the maximum image radius to limit the effect
%   of distortion to the image plane. The image radius is one half of the
%   image diagonal. In case norm(UP) > RMAX then UD = RMAX/norm(UP)*UP. The
%   Jacobians are trivially computed just for argument consistency: UDup =
%   eye(2) and UDdist = zeros(2,length(dist)).

% (c) 2006 Joan Sola @ LAAS-CNRS

r2 = sum(up.^2);

n = length(dist);
    
if 0%nargin == 3 && any(r2 > rmax^2) 
    %   FIXME: RMAX works not so nice
    
    rdmax = rmax;
    
    mr    = ones(size(r2));
    
    for i=1:n
        
        rdmax = rdmax + dist(i)*rmax^(2*i+1);
        
        mr    = mr + (2*i+1)*dist(i)*rmax^(2*i);
        
    end
    
    r  = sqrt(r2);
    
    rd = rdmax + mr.*(r-rmax);

    ratio = rd/r;
    
    ud     = ratio*up;
    
    UDup   = mr*eye(2);
    UDdist = zeros(2,length(dist));
    
else

    ratio = ones(size(r2));
    for i=1:n
        ratio = ratio + dist(i)*r2.^i;
    end

    ud = up.*[ratio;ratio];

    if nargout > 1 % jacobians (up to 3rd order)
        u1 = up(1);
        u2 = up(2);
        dist(end+1:3) = 0; % in case dist is shorter than 3
        k2 = dist(1);
        k4 = dist(2);
        k6 = dist(3);
        
        r4 = r2^2;
        r6 = r2*r4;

        UDup = [...
            [ 1+k2*r2+k4*r4+k6*r6+u1*(2*k2*u1+4*k4*r2*u1+6*k6*r4*u1),                     u1*(2*k2*u2+4*k4*r2*u2+6*k6*r4*u2)]
            [                     u2*(2*k2*u1+4*k4*r2*u1+6*k6*r4*u1), 1+k2*r2+k4*r4+k6*r6+u2*(2*k2*u2+4*k4*r2*u2+6*k6*r4*u2)]];
        UDdist = [...
            [   u1*r2, u1*r4, u1*r6]
            [   u2*r2, u2*r4, u2*r6]];

        UDdist(:,n+1:end) = []; % remove unused positions for DIST shorter than 3.

    end

end

return

%% Build jacobians up to order 3
% For higher orders:
%   1/ add k8,k10,k(2n)... to syms line below for an order n.
%   2/ add k8,k10,k(2n)... to vector dist below for an order n.
%   3/ Execute this cell (Apple+return keys)
%   4/ Copy the results in UDup and UDdist above, caring for the matrices'
%   opening and closing brackets (do not forget them).

syms u1 u2 k2 k4 k6 real
up   = [u1;u2];
dist = [k2;k4;k6];
ud   = distort(up,dist);

UDup   = simple(jacobian(ud,up))
UDdist = simple(jacobian(ud,dist))
