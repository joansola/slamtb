function [up,UPud,UPundist] = undistort(ud,unDist)

% UNDISTORT  Undistorts projected point with radial distortion.
%   UNDISTORT(UD,UNDIST) computes the position in the image plane
%   of the projected pixel corresponding to the distorted pixel
%   UD. UNDIST is the vector of distortion parameters.
%   Undistortion is calculated with the radial distortion model:
%
%     UP = UD * (1 + k2*r^2 + k4*r^4 + k6*r^6 + ...)
%
%   where r^2 = UD(1)^2 + UD(2)^2
%     and UNDIST = [k2 k4 k6 ...]
%
%   [ud,UDup,UDundist] = UNDISTORT(...) returns Jacobians wrt UD and UNDIST. Only
%   UNDIST vectors of up to order 4 are supported. If a higher order is
%   desired use a Jacobian builder at the bottom of UNDISTORT.M file (and read the
%   notes that come with it).

% (c) 2006-2008 Joan Sola @ LAAS-CNRS

r2 = sum(ud.^2);

n = length(unDist);

ratio = ones(size(r2));
for i=1:n
    ratio = ratio + unDist(i)*r2.^i;
end

up = ud.*[ratio;ratio];

if nargout > 1 % jacobians (up to 3rd order)

    if n <= 3

        u1 = ud(1);
        u2 = ud(2);
        unDist(end+1:3) = 0; % in case unDist is shorter than 3
        k2 = unDist(1);
        k4 = unDist(2);
        k6 = unDist(3);

        UPud = [...
            [ 1+k2*(u1^2+u2^2)+k4*(u1^2+u2^2)^2+k6*(u1^2+u2^2)^3+u1*(2*k2*u1+4*k4*(u1^2+u2^2)*u1+6*k6*(u1^2+u2^2)^2*u1),                                                    u1*(2*k2*u2+4*k4*(u1^2+u2^2)*u2+6*k6*(u1^2+u2^2)^2*u2)]
            [                                                    u2*(2*k2*u1+4*k4*(u1^2+u2^2)*u1+6*k6*(u1^2+u2^2)^2*u1), 1+k2*(u1^2+u2^2)+k4*(u1^2+u2^2)^2+k6*(u1^2+u2^2)^3+u2*(2*k2*u2+4*k4*(u1^2+u2^2)*u2+6*k6*(u1^2+u2^2)^2*u2)]];
        UPundist = [...
            [   u1*(u1^2+u2^2), u1*(u1^2+u2^2)^2, u1*(u1^2+u2^2)^3]
            [   u2*(u1^2+u2^2), u2*(u1^2+u2^2)^2, u2*(u1^2+u2^2)^3]];

        UPundist(:,n+1:end) = []; % remove unused positions for UNDIST shorter than unDist.

    elseif n == 4 % Jacobians order 4
        
        u1 = ud(1);
        u2 = ud(2);
        
        k2 = unDist(1);
        k4 = unDist(2);
        k6 = unDist(3);
        k8 = unDist(4);

        UPud = [...
            [ 1+k2*(u1^2+u2^2)+k4*(u1^2+u2^2)^2+k6*(u1^2+u2^2)^3+k8*(u1^2+u2^2)^4+u1*(2*k2*u1+4*k4*(u1^2+u2^2)*u1+6*k6*(u1^2+u2^2)^2*u1+8*k8*(u1^2+u2^2)^3*u1),                                                                     u1*(2*k2*u2+4*k4*(u1^2+u2^2)*u2+6*k6*(u1^2+u2^2)^2*u2+8*k8*(u1^2+u2^2)^3*u2)]
            [                                                                     u2*(2*k2*u1+4*k4*(u1^2+u2^2)*u1+6*k6*(u1^2+u2^2)^2*u1+8*k8*(u1^2+u2^2)^3*u1), 1+k2*(u1^2+u2^2)+k4*(u1^2+u2^2)^2+k6*(u1^2+u2^2)^3+k8*(u1^2+u2^2)^4+u2*(2*k2*u2+4*k4*(u1^2+u2^2)*u2+6*k6*(u1^2+u2^2)^2*u2+8*k8*(u1^2+u2^2)^3*u2)]];
        UPundist = [...
            [   u1*(u1^2+u2^2), u1*(u1^2+u2^2)^2, u1*(u1^2+u2^2)^3, u1*(u1^2+u2^2)^4]
            [   u2*(u1^2+u2^2), u2*(u1^2+u2^2)^2, u2*(u1^2+u2^2)^3, u2*(u1^2+u2^2)^4]];

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

syms u1 u2 k2 k4 k6 k8 real

ud = [u1;u2];
unDist = [k2;k4;k6;k8];

up   = undistort(ud,unDist);

UPud   = simple(jacobian(up,ud))
UPundist = simple(jacobian(up,unDist))


%% test jacobians
syms u1 u2 k2 k4 k6 k8 real

ud = [u1;u2];
unDist = [k2;k4;k6;k8];

[up,UPud,UPundist]   = undistort(ud,unDist);

UPud   - simple(jacobian(up,ud))
UPundist - simple(jacobian(up,unDist))
