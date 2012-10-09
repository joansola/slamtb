% LINES 2D and 3D line manipulations.
%
% Plucker lines
%   fromFramePlucker    - Transform plucker line from a given frame.
%   toFramePlucker      - Transform plucker line to a given frame.
%   planeBase2dirVector - Plucker line dir. vector from base spec.
%   planeVec2planeBase  - Orthonormal base for a plane
%   points2plucker      - Plucker line from two homogeneous points
%   pluckerEndpoints    - Plucker line and abscissas to endpoints conversion.
%   pluckerOrigin       - Plucker line origin.
%   pluckerAngle        - Angle between Plucker vectors.
%   pix2PluckerRay      - Plucker ray from optical center through pixel.
%   lines2point         - Intersection point of 2 Plucker lines. Result in Homogeneous.
%   lines2Epoint        - Intersection point of 2 Plucker lines. Result in Euclidean.
%   intersectPlucker    - Intersect Plucker lines, get point and abscissa.
%   updatePlkLinEndPnts - Update Plucker endpoints.
%
% Anchored Plucker lines
%   anchorPlucker       - Plucker to anchored Plucker line conversion
%   fromFrameAPlucker   - Anchored Plucker fromFrame transform.
%   toFrameAPlucker     - Anchored Plucker toFrame transform.
%   reanchorPlucker     - Plucker to anchored Plucker line conversion
%   unanchorPlucker     - Remove Plucker anchor.
%   updateAplLinEndPnts - Update anchored Plucker endpoints.
%   aPluckerSegment     - Anchored Plucker line's segment from abscissas.
%
% Inverse depth lines
%   updateIdpLinEndPnts - Update IDP line endpoints.
%   fromFrameIdpLin     - Transforms IDP line from local frame to global frame.
%   idpLin2idpPnts      - IDP line to two IDP points conversion.
%   idpLin2seg          - IDP line to segment conversion
%   idpLinEndpoints     - IDP line endpoints.
%   idpLinSegment       - IDP line endpoints.
%   app2idpLin          - APP2IDL Anchor and points to inverse depth line conversion.
%
% 3D segments (defined by two endpoints, stacked in one vector)
%   toFrameSegment      - Express in local frame a set of segments from global frame
%   segLength           - Segment length.
%   seg2pvLin           - Segment to point-vector line transform.
%   intersectSegments   - Intersect two 3d segments.
%
% Other 3d line types
%   intersectPvLines    - Intersect two point-vector lines.
%   vecsAngle           - Angle between two vectors.
%
% 2D lines - mixed hmg, pp, seg, ...
%   trimSegment         - Trim segment at image borders
%   trimHmgLin          - Trim 2D homogeneous line at image borders
%   intersectHmgLin     - Intersection of 2 homogeneous lines.
%   hmgLin2rt           - Homogeneous to rho-theta line expression in the plane.
%   pp2hmgLin           - Homogeneous line from two homogeneous points
%   pp2rt               - Points to rho theta 2D line conversion.
%   rt2hmgLin           - Rho-theta to homogeneous line conversion.
%   seg2hmgLin          - Segment to homogeneous line conversion.
%   lp2d                - Line-point signed distance, in 2D.
%   hms2hh              - Orthogonal endpoints innovation for homogeneous line and segment.
%   seg2rt              - Segment to rho-theta conversion.
%
% Other line types
%   ahmLin2ahmPnts      - AHM line to two AHM points conversion.
%   ahmLin2seg          - HMG line to segment conversion
%   ahmLinEndpoints     - AHM line endpoints.
%   ahmLinSegment       - AHM line endpoints.
%   fromFrameAhmLin     - Transforms AHM line from local frame to global frame.
%   fromFrameHmgLin     - Transforms HMG line from local frame to global frame.
%   hmgLin2hmgPnts      - HMG line to two IDP points conversion.
%   hmgLin2seg          - HMG line to segment conversion
%   hmgLinEndpoints     - HMG line endpoints.
%   hmgLinSegment       - HMG line endpoints.
%   updateAhmLinEndPnts - Update AHM line endpoints.
%   updateHmgLinEndPnts - Update HMG line endpoints.
