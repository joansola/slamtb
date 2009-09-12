% POINTS  Point manipulations.
%
% Files
%   fromFrame    - Express in global frame a set of points from a local frame.
%   toFrame      - Express in local frame a set of points from global frame.
%   fromFrameIdp - Transforms IDP from local frame to global frame.
%   toFrameIdp   - Transforms IDP from global frame to local frame.
%   p2idp        - Point to inverse-depth point conversion.
%   idpS2idpW    - Transform idp vector from "Sensor frame" to "World frame".
%   py2vec       - Pitch and yaw to 3D direction vector.
%   vec2py       - 3D vector to pitch and yaw direction
%   euc2hmg      - Euclidean to Homogeneous point transform.
%   fromFrameHmg - Fom-frame transformation for homogeneous coordinates
%   hmg2euc      - Homogeneous to Euclidean point transform.
%   homogeneous  - Build motion matrix.
%   idp2euc      - Inverse Depth to cartesian point conversion.
%   xyzLinTest   - Linearity test of cartesian point given inverse depth point
%   ahm2euc      - Inverse Depth to cartesian point conversion.
%   fromFrameAhm - Transforms AHM from local frame to global frame.
%   fromFrameVec - From frame function for vectors.
