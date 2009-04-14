% Observation models and vision library.
%
% Sensor management
%   composeRobSen                  - Compose robot and sensor frames and parameters.
%
% Pin-hole model functions
%   depixellise                    - Pixellic to metric conversion
%   distort                        - Distort projected point with radial distortion.
%   intrinsic                      - Build intrinsic matrix
%   invDistortion                  - Radial distortion correction calibration.
%   invIntrinsic                   - Build inverse intrinsic matrix
%   invPinHole                     - Inverse pin-hole camera model, with radial distortion correction.
%   invPinHoleIdp                  - Inverse pin-hole camera model for IDP, with radial distortion correction.
%   pinHole                        - Pin-hole camera model, with optional radial distortion.
%   pinHoleIdp                     - Pin-hole camera model for Inverse depth points, with radial distortion.
%   pixellise                      - Metric to pixellic conversion
%   project                        - Project point into plane using pin-hole camera model
%   retro                          - Retroproject pixel into 3D space.
%   undistort                      - Undistorts projected point with radial distortion.
%   isVisible                          - Points visible from pinHole camera.
%
% Observation models, with 2 frame transforms
%   retroProjectIdpPntFromPinHoleOnRob - Retro-pr idp from pinhole on rob.
%   projEucPntIntoPinHoleOnRob         - Project Euc pnt into pinhole on robot.
