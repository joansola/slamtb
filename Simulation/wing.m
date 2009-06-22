function v = wing(size)

% WING  creates a wing graphics 3D object.
%   WING creates a multi-patch object representing a plane, sort of a
%   hang-glider wing.
%   
%   WING(SIZE) allows for choosing the wing's size. Default is 1.

if nargin == 0
    size = 1;
end

v.vert0 = [ 0.6  0.0 0.0
           -0.6  1.0 0.0
           -0.4  0.0 0.0
           -0.6 -1.0 0.0
           -0.4  0.0 0.3
            0.0  0.0 0.0] * size/2;
       
v.vert = v.vert0;
v.faces = [1 2 3 4
           3 5 6 3];      
