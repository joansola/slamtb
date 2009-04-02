function [u, s, U_p, U_k, U_d] = pinHole(p,k,d)

% PINHOLE Pin-hole camera model, with radial distortion.
%   U = PINHOLE(P) gives the projected pixel U of a point P in a canonical
%   pin-hole camera, that is, with calibration parameters
%     u0 = 0
%     v0 = 0
%     au = 1
%     av = 1
%   It uses reference frames {RDF,RD} (right-down-front for the 3D world
%   points and right-down for the pixel), according to this scheme:
%
%         / z (forward)
%        /
%       +------- x                 +------- u
%       |                          |
%       |      3D : P=[x;y;z]      |     image : U=[u;v]
%       | y                        | v
%
%   U = PINHOLE(P,K) allows the introduction of the camera's calibration
%   parameters:
%     K = [u0 v0 au av]'
%
%   U = PINHOLE(P,K,D) allows the introduction of the camera's radial
%   distortion parameters:
%     D = [K2 K4 K6 ...]'
%   so that the new pixel is distorted following the distortion equation:
%     U_D = U * (1 + K2*R^2 + K4*R^4 + ...)
%   with R^2 = sum(U.^2), being U the projected point in the image plane
%   for a camera with unit focal length.
%
%   [U,S] = PINHOLE(...) returns the vector S of depths from the camera
%   center.
%
%   If P is a points matrix, PINHOLE(P,...) returns a pixel matrix U and a
%   depths row-vector S. P, U and S are defined as
%     P = [P1 ... Pn];   Pi = [xi;yi;zi]
%     U = [U1 ... Un];   Ui = [ui;vi]
%     S = [S1 ... Sn]
%
%   [U,S,U_p,U_k,U_d] returns the Jacobians of U wrt P, K and D. It only
%   works for single points P=[x;y;z], and for distortion vectors D of up
%   to 3 parameters D=[d2;d4;d6]. See DISTORT for information on longer
%   distortion vectors.
%
%   See also PROJECT, DISTORT, PIXELLISE, INVPINHOLE, PINHOLEIDP.

% (c) 2009 Joan Sola @ LAAS-CNRS

% Point's depth
s = p(3,:);

if nargout <= 2 % only pixel

    switch nargin
        case 1
            u = project(p);
        case 2
            u = pixellise(project(p),k);
        case 3
            if ~isempty(d)
                u = pixellise(distort(project(p),d),k);
            else
                u = pixellise(project(p),k);
            end
    end


else % Jacobians

    if size(p,2) > 1
        error('Jacobians not available for multiple points')
    else

        switch nargin
            case 1
                [u, U_p] = project(p);

            case 2
                [u1, U1_p]     = project(p);
                [u, U_u1, U_k] = pixellise(u1,k);
                U_p            = U_u1*U1_p;

            case 3
                if ~isempty(d)
                    [u1, U1_p]        = project(p);
                    [u2, U2_u1, U2_d] = distort(u1,d);
                    [u, U_u2, U_k]    = pixellise(u2,k);
                    U_d               = U_u2*U2_d;
                    U_p               = U_u2*U2_u1*U1_p;
                else
                    [u1, U1_p]     = project(p);
                    [u, U_u1, U_k] = pixellise(u1,k);
                    U_p            = U_u1*U1_p;
                    U_d            = zeros(2,0);
                end

        end

    end

end

return

%% jacobians
syms x y z u0 v0 au av d2 d4 d6 real
p = [x;y;z];
k = [u0;v0;au;av];
d = [d2;d4;d6];

[u, s, U_p, U_k, U_d] = pinHole(p,k,d);

simplify(U_p - jacobian(u,p))
simplify(U_k - jacobian(u,k))
simplify(U_d - jacobian(u,d))

