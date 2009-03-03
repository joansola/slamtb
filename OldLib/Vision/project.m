function [u,Up] = project(p)

% PROJECT  Project point into plane using pin-hole camera model
%   U = PROJECT(P) projects the point P into the image plane
%   situated at a focal distance of 1m.

u = [p(1,:)./p(3,:) ; p(2,:)./p(3,:)];

if nargout > 1 % jacobians
    
    x = p(1);
    y = p(2);
    z = p(3);
    
    Up = [...
        [    1/z,      0, -x/z^2]
        [      0,    1/z, -y/z^2]];
end
