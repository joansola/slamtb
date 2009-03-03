function [g_F,G] = gravity(ori)

% GRAVITY  take local gravity vector from given orientation
%   GRAVITY(E) gives the local gravity measure in a frame specified by 
%   Euler angles E.
%
%   GRAVITY(Q) uses quaternion Q for frame orientation.
%
%   Sorry: rotation vectors V are not supported.
%
%   [g_F,G] = GRAVITY(...) gives the Jacobian G of this function wrt the
%   input argument. Both E and Q are supported.

if isEuler(ori) % Euler
    r = ori(1);
    p = ori(2); % yaw is not used!
    
    g_F = [sin(p); -sin(r)*cos(p); -cos(r)*cos(p)];
    
    if nargout == 2
        G = [      0           cos(p)     0
            -cos(r)*cos(p) sin(r)*sin(p)  0
             sin(r)*cos(p) cos(r)*sin(p)  0];
    end
elseif isQuat(ori) % Quaternion
    a = ori(1);
    b = ori(2);
    c = ori(3);
    d = ori(4);
    
    g_F = [-2*(b*d-a*c); -2*(c*d+a*b); -a*a + b*b + c*c - d*d];
    
    if nargout == 2
        G = 2*[c -d  a -b
              -b -a -d -c
              -a  b  c -d];
    end
else
    error('Input vector does not correspond to an orientation')
end

