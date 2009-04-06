function [u,Up] = project(p)

% PROJECT  Project point into plane using pin-hole camera model
%   U = PROJECT(P) projects the point P into the image plane
%   situated at a focal distance of 1m. It also works for sets of points if
%   they are defined by the matrix P = [P1 ... Pn], with Pi = [xi;yi;zi].
%
%   [U,Up] = PROJECT(P) returns the Jacobian wrt P. This only works for
%   single points, not for sets of points.
%
%   See also PINHOLE.


u = [p(1,:)./p(3,:) ; p(2,:)./p(3,:)];

if nargout > 1 % jacobians

    if size(p,2)>1
        error('Jacobians not possible for multiple points')
    else

        [x,y,z] = split(p);

        Up = [...
            [    1/z,      0, -x/z^2]
            [      0,    1/z, -y/z^2]];
    end
end
