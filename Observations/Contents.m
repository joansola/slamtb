% Observation models and vision library.
%
% Sensor management
%   composeRobSen                  - Compose robot and sensor frames and parameters.
%
% Pin-hole model functions
%   project                        - Project point into plane using pin-hole camera model
%   retro                          - Retroproject pixel into 3D space.
%   distort                        - Distort projected point with radial distortion.
%   undistort                      - Undistorts projected point with radial distortion.
%   pixellise                      - Metric to pixellic conversion
%   depixellise                    - Pixellic to metric conversion
%   intrinsic                      - Build intrinsic matrix
%   invIntrinsic                   - Build inverse intrinsic matrix
%   pinHole                        - Pin-hole camera model, with optional radial distortion.
%   invPinHole                     - Inverse pin-hole camera model, with radial distortion correction.
%   pinHoleIdp                     - Pin-hole camera model for Inverse depth points, with radial distortion.
%   invPinHoleIdp                  - Inverse pin-hole camera model for IDP, with radial distortion correction.
%   pinHolePlucker                 - Projects plucker line.
%   invPinHolePlucker              - Retro-projects plucker line
%   aInvPinHolePlucker             - Inverse pin hole model for Plucker lines
%   pinHoleSegment                 - Pin hole projection of a segment.
%   pluckerInvCamera                - Inverse Plucker projection matrix
%   isVisible                      - Points visible from pinHole camera.
%   invDistortion                  - Radial distortion correction calibration.
%
% Observation models, with 2 frame transforms
%   projEucPntIntoPinHoleOnRob      - Project Euc pnt into pinhole on robot.
%   projIdpPntIntoPinHoleOnRob      - Project Idp pnt into pinhole on robot.
%   retroProjIdpPntFromPinHoleOnRob - Retro-project idp from pinhole on robot.
%   projPlkLinIntoPinHoleOnRob      - Project Plucker line into pinhole on robot.
%   retroProjPlkLinFromPinHoleOnRob - Retro-project Plucker line from pinhole on robot.
