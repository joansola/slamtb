function v = thickVehicle(size)

% CREATEVEHICLE  creates a vehicle graphics 3D object
%
%   CREATEVEHICLE creates a thick triangle representing a vehicle
%   This triangle is heading towards vehicle principal axis
%   and is located at vehicle position. Initial configuration
%   is: position at origin and principal axis aligned with
%   world x axis.
%   
%   CREATEVEHICLE(SIZE) allows for choosing a vehicle size. 
%   Default is 0.5

if nargin == 0
    size = 1;
end

v.vert0 = [ 1.0  0.0 0.0
           -0.5  0.5 0.0
           -0.5 -0.5 0.0
            1.0  0.0 0.5
           -0.5  0.5 0.5
           -0.5 -0.5 0.5] * size/2;
       
v.vert = v.vert0;
v.faces = [1 2 3 1
           4 5 6 4
           1 2 5 4 
           1 3 6 4 
           2 3 6 5];      
