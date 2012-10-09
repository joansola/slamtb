% POINTS  Point manipulations.
%
% Frame transformations
%   fromFrame     - Express in global frame a set of points from a local frame.
%   toFrame       - Express in local frame a set of points from global frame.
%   fromFrameIdp  - Transforms IDP from local frame to global frame.
%   toFrameIdp    - Transforms IDP from global frame to local frame.
%   fromFrameHmg  - Fom-frame transformation for homogeneous coordinates
%   toFrameHmg    - To-frame transformation for homogeneous coordinates
%   fromFrameAhm  - Transforms AHM from local frame to global frame.
%   fromFrameVec  - From frame function for vectors.
%
% Conversion between parametrizations
%   p2idp         - Point to inverse-depth point conversion.
%   py2vec        - Pitch and yaw to 3D direction vector.
%   vec2py        - 3D vector to pitch and yaw direction
%   euc2hmg       - Euclidean to Homogeneous point transform.
%   hmg2euc       - Homogeneous to Euclidean point transform.
%   idp2euc       - Inverse Depth to cartesian point conversion.
%   ahp2idp       - IDP to AHP point transformation.
%   idp2ahp       - IDP to AHP point transformation.
%   ahm2euc       - Inverse Depth to cartesian point conversion.
%
% Linearity tests
%   ahmLinearTest - Linearity test of cartesian point given inverse depth point
%   idpLinearTest - Linearity test of cartesian point given inverse depth point
%
% Tools
%   homogeneous   - Build motion matrix.
