% Observation models and vision library.
%
% Sensor management
%   composeRobSen                   - Compose robot and sensor frames and parameters.
%
% Pin-hole model functions
%   project                         - Project point into plane using pin-hole camera model
%   retro                           - Retroproject pixel into 3D space.
%   distort                         - Distort projected point with radial distortion.
%   undistort                       - Undistorts projected point with radial distortion.
%   pixellise                       - Metric to pixellic conversion
%   depixellise                     - Pixellic to metric conversion
%   intrinsic                       - Build intrinsic matrix
%   invIntrinsic                    - Build inverse intrinsic matrix
%   pinHole                         - Pin-hole camera model, with optional radial distortion.
%   invPinHole                      - Inverse pin-hole camera model, with radial distortion correction.
%   pinHoleIdp                      - Pin-hole camera model for Inverse depth points, with radial distortion.
%   invPinHoleIdp                   - Inverse pin-hole camera model for IDP, with radial distortion correction.
%   pinHolePlucker                  - Projects plucker line.
%   invPinHolePlucker               - Retro-projects plucker line
%   aInvPinHolePlucker              - Inverse pin hole model for Plucker lines
%   pinHoleSegment                  - Pin hole projection of a segment.
%   pluckerInvCamera                - Inverse Plucker projection matrix
%   isVisible                       - Points visible from pinHole camera.
%   invDistortion                   - Radial distortion correction calibration.
%   invPinHoleHmg                   - Inverse pin-hole camera model for HMG.
%   visibleSegment                  - Visible segment.
%   invPinHoleAPlucker              - Retro-projects anchored plucker line
%   invPinHoleIdpLin                - IDP line retro projection.
%   invPinHoleAhm                   - Retro-project anchored homogeneous point AHP.
%
% Observation models, with 2 frame transforms
%   projEucPntIntoPinHoleOnRob      - Project Euc pnt into pinhole on robot.
%   projIdpPntIntoPinHoleOnRob      - Project Idp pnt into pinhole on robot.
%   projHmgPntIntoPinHoleOnRob      - Project Hmg pnt into pinhole on robot.
%   projSegLinIntoPinHoleOnRob      - Project segment line into pinhole on robot.
%   projPlkLinIntoPinHoleOnRob      - Project Plucker line into pinhole on robot.
%   projAplLinIntoPinHoleOnRob      - Project anchored Plucker line into pinhole on robot.
%   projIdpLinIntoPinHoleOnRob      - Project Idp line into pinhole on robot.
%   retroProjLmk                    - Retro project landmark.
%   retroProjIdpPntFromPinHoleOnRob - Retro-project idp from pinhole on robot.
%   retroProjHmgPntFromPinHoleOnRob - Retro-proj. Hmg pnt from pinhole on rob.
%   retroProjPlkLinFromPinHoleOnRob - Retro-project Plucker line from pinhole on robot.
%   retroProjPlkEndPnts             - Retro project Plucker endpoints.
%   retroProjAplLinFromPinHoleOnRob - Retro-project anchored Plucker line from pinhole on robot.
%   retroProjAplEndPnts             - Retro project anchored Plucker endpoints.
%   retroProjIdpLinFromPinHoleOnRob - retroprj Idp Line from pinhole on robot.
%   projAhmPntIntoPinHoleOnRob      - Project Idp pnt into pinhole on robot.
%   retroProjAhmPntFromPinHoleOnRob - Retro-project ahm from pinhole on robot.
