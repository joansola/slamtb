function Rb2s = flu2rdf

% FLU2RDF Camera body to camera sensor rotation matrix
%   FLU2RDF computes the rotation matrix for a camera whos body
%   is in the FLU frame (x-front, y-left, z-up) and its sensor in
%   the RDF frame (x-right, y-down, z-front)

Rb2s = e2R([-pi/2 0 -pi/2]');
