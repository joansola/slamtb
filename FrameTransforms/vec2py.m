function [py,PYv] = vec2py(v)

% VEC2PY  3D vector to pitch and yaw direction
%   [PY] = VEC2PY(V) returns a vector PY with the pitch and yaw angles of
%   the directed vector V wrt the frame where V is defined.
%
%   [PY,PYv] = VEC2PY(...) returns also the Jacobian wrt V.

% (c) Joan Sola 2008

[x,y,z] = split(v);

xy2  = x^2 + y^2;
xyz2 = xy2 + z^2;

rxy = sqrt(xy2);

w   = whos('x');
if strcmp(w.class,'sym')
    % symbolic
    pitch = atan(z/rxy);
    yaw   = atan(y/x);
else
    % numeric
    pitch = atan2(z,rxy);
    yaw   = atan2(y,x);
end

py = [pitch;yaw];

if nargout == 2 % we want the Jacobian

    PYv = [...
        [ -z/rxy*x/xyz2, -z/rxy*y/xyz2,  rxy/xyz2]
        [        -y/xy2,         x/xy2,         0]];

end

return

%% Symbolic part for the Jacobian (uncomment symbolic lines above)

syms x y z real

v = [x;y;z];

py = vec2py(v);

PYv = simple(jacobian(py,v))

[py2,PYv2] = vec2py(v)

EPYv = simple(PYv-PYv2)
