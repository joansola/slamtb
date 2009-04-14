% Frame transformations.
%
% Frames
%   frame         - Help on frames for the FrameTransforms/ toolbox.
%   getTR         - Get translation vector and rotation matrix
%   splitFrame    - Split frame information into useful matrices and vectors.
%   splitInvFrame - Split frame information into useful matrices and vectors.
%   composeFrames - Compose two 3D frames.
%   epose2qpose   - Euler-specified to quaternion-specified pose conversion.
%   qpose2epose   - Quaternion-specified to Euler-specified pose conversion.
%   updateFrame   - Update frame structure.
%
% 3D Euclidean points
%   fromFrame     - Express in global frame a set of points from a local frame.
%   toFrame       - Express in local frame a set of points from global frame.
%   Rp            - Rotation matrix (from quaternion) times vector.
%   Rtp           - Transposed rotation matrix (from quaternion) times vector.
%   frame2iMatrix - Frame to motion matrix.
%   frame2matrix  - Frame to motion matrix.
%
% Inverse depth points
%   fromFrameIdp  - Transforms IDP from local frame to global frame.
%   toFrameIdp    - Transforms IDP from global frame to local frame.
%   idp2p         - Inverse Depth to cartesian point conversion.
%   py2vec        - Pitch and yaw to 3D direction vector.
%   p2idp         - Point to inverse-depth point conversion.
%   vec2py        - 3D vector to pitch and yaw direction
%   idpS2idpW     - transpose idp vector from "Sensor frame" to "World frame".
