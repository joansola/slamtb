% Observation models and vision library.
%
% Sensor management
%   composeRobSen                   - Compose robot and sensor frames and parameters.
%
% Pin-hole model functions
%   distort                         - Distort projected point with radial distortion.
%   undistort                       - Undistorts projected point with radial distortion.
%   pixellise                       - Metric to pixellic conversion
%   depixellise                     - Pixellic to metric conversion
%   intrinsic                       - Build intrinsic matrix
%   invIntrinsic                    - Build inverse intrinsic matrix
%   essential                       - Essential matrix from frame specification.
%   fundamental                     - Fundamental matrix between 2 cameras.
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
%   invPinHoleHmg                   - Retro-project anchored homogeneous point AHP.
%   visibleSegment                  - Visible segment.
%   invPinHoleAPlucker              - Retro-projects anchored plucker line
%   invPinHoleIdpLin                - IDP line retro projection.
%   invPinHoleAhm                   - Retro-project anchored homogeneous point AHP.
%   persp_project                   - Project point into plane using pin-hole camera model
%   persp_retro                     - Retroproject pixel into 3D space.
%   pinHoleHmg                      - Pin-hole camera model for HMG points, with optional radial distortion.
%   projAhmPntIntoPinHole           - Project AHM pnt into pinhole camera.
%   projIdpPntIntoPinHole           - Project Idp pnt into pinhole.
%   invPinHoleDepth                 - 
%   pinHoleDepth                    - Pin hole projection with distance measurement
%
% Functions related to Omnicam camera model
%   depixelliseOmniCam              - TODO: can inverse A up front - will save calculation esp in Jac part
%   invOmniCam                      - Inverse omnidirectional camera model
%   invOmniCamAhm                   - Retro-project anchored homogeneous point AHP.
%   invPinHoleAhmLin                - AHM line retro projection.
%   invPinHoleHmgLin                - IDP line retro projection.
%   omniCam                         - Gives projected pixel u of 3D point p for Omnidirectional Camera model
%   omni_project                    - Gives projected pixel u of 3D point p for Omnidirectional Camera model
%   omni_retro                      - Retroproject pixel into 3D space.
%   pixelliseOmniCam                - Omnicam Affine correction step
%
% Observation models, with 2 frame transforms
%   projEucPntIntoPinHoleOnRob      - Project Euc pnt into pinhole on robot.
%   projIdpPntIntoPinHoleOnRob      - Project Idp pnt into pinhole on robot.
%   projHmgPntIntoPinHoleOnRob      - Project Hmg pnt into pinhole on robot.
%   projSegLinIntoPinHoleOnRob      - Project segment line into pinhole on robot.
%   projPlkLinIntoPinHoleOnRob      - Project Plucker line into pinhole on robot.
%   projAplLinIntoPinHoleOnRob      - Project anchored Plucker line into pinhole on robot.
%   projIdpLinIntoPinHoleOnRob      - Project Idp line into pinhole on robot.
%   retroProjIdpPntFromPinHoleOnRob - Retro-project idp from pinhole on robot.
%   retroProjHmgPntFromPinHoleOnRob - Retro-proj. Hmg pnt from pinhole on rob.
%   retroProjPlkLinFromPinHoleOnRob - Retro-project Plucker line from pinhole on robot.
%   retroProjPlkEndPnts             - Retro project Plucker endpoints.
%   retroProjAplLinFromPinHoleOnRob - Retro-project anchored Plucker line from pinhole on robot.
%   retroProjAplEndPnts             - Retro project anchored Plucker endpoints.
%   retroProjIdpLinFromPinHoleOnRob - retroprj Idp Line from pinhole on robot.
%   projAhmPntIntoPinHoleOnRob      - Project Ahm pnt into pinhole on robot.
%   retroProjAhmPntFromPinHoleOnRob - Retro-project ahm from pinhole on robot.
%   projAhmLinIntoPinHoleOnRob      - Project Ahm line into pinhole on robot.
%   projHmgLinIntoPinHoleOnRob      - Project Hmg line into pinhole on robot.
%   retroProjAhmLinFromPinHoleOnRob - retroprj Ahm Line from pinhole on robot.
%   retroProjHmgLinFromPinHoleOnRob - retroprj Hmg Line from pinhole on robot.
%   projAhmPntIntoOmniCamOnRob      - Project Ahm pnt into omnidirectional camera on robot.
%   projEucPntIntoOmniCamOnRob      - Project Euc pnt into omnidirec cam on robot.
%   retroProjAhmPntFromOmniCamOnRob - Retro-project ahm from omnicam on robot.
%   projEucPntIntoPhdOnRob          - Project Eucliden point into Pinhole-depth in Robot
%   retroProjEucPntFromPhdOnRob     - Retro-proj Euc. pnt. from Pinhole-depth in Rob

