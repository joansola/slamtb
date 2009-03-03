function [e,vis] = projectSegment(C,k,s,imSize)

% PROJECTSEGMENT  Project segment into projective camera.
%   PROJECTSEGMENT(C,K,S) projects the segment S into a camera at pose C
%   and with intrinsic parameters K. The input segment S is a 6-vector of
%   the two stacked Euclidean 3-endpoints. The returned segment is a
%   4-vector of the 2 stacked Euclidean 2-points.
%
%   PROJECTSEGMENT(C,K,S), with S a 6-by-N matrix, projects all the
%   segments of object S. The result is a 4-by-N segments image.
%
%   PINHOLESEGMENT(C,K,S,IMSIZE) accepts the image size IMSIZE=[HSIZE,VSIZE]
%   with which the output segment is trimmed.
%
%   PINHOLESEGMENT(C,S), accepts the stucture C containing the camera
%   parameters:
%       .X      the camera frame
%       .cal    the camera intrinsic aprameters
%       .imSize the image size
%
%   See also PINHOLESEGMENT, TOFRAMESEGMENT, TRIMSEGMENT.

switch nargin
    case 2 % camera structure
        imSize = C.imSize;
        s = k;
        k = C.cal;
        C = C.X;
        [e,vis] = pinHoleSegment(k,toFrameSegment(C,s),imSize);
    case 3
        [e,vis] = pinHoleSegment(k,toFrameSegment(C,s));
    case 4
        [e,vis] = pinHoleSegment(k,toFrameSegment(C,s),imSize);
end
