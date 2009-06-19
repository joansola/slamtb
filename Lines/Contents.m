% LINES 2D and 3D line manipulations.
%
% Plucker lines
%   aInvPinHolePlucker  - Inverse pin hole model for Plucker lines
%   fromFramePlucker    - Transform plucker line from a given frame.
%   planeBase2dirVector - Plucker line dir. vector from base spec.
%   planeVec2planeBase  - Orthonormal base for a plane
%   pluckerAngle        - Angle between Plucker vectors.
%   points2plucker      - Plucker line from two homogeneous points
%   projectPlucker      - Project Plucker line
%   retroProjectPlucker - Retro project Plucker line
%   toFramePlucker      - Transform plucker line to a given frame.
%
% Anchored Plucker lines
%   anchorPlucker       - Plucker to anchored Plucker line conversion
%   fromFrameAPlucker   - Anchored Plucker fromFrame transform.
%   toFrameAPlucker     - Anchored Plucker toFrame transform.
%   projectAPlucker     - Project anchored Plucker line
%   reanchorPlucker     - Plucker to anchored Plucker line conversion
%   unanchorPlucker     - Remove Plucker anchor.
%
% Inverse depth lines
%   idl2pp              - Inverse depth line to passage points.
%   intersectPpLines    - Intersect two point-point lines.
%   intersectPvLines    - Intersect two point-vector lines.
%   ppLine2pvLine       - Points line to point-vector line transform.
%   ppp2idl             - Points to inverse depth line conversion.
%   updateEndPoints     - 3D landmark, IDL is Inverse Depth Line
%
% Segments (2D lines)
%   trimSegment         - Trim segment at image borders
%   hmgLin2rt           - Homogeneous to rho-theta line expression in the plane.
%   pp2hmgLin           - Homogeneous line from two homogeneous points
%   rt2hmgLin           - Rho-theta to homogeneous line conversion.
%   seg2hmgLin          - Segment to homogeneous line conversion.
%   pp2rt               - Points to rho theta 2D line conversion.
