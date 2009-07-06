function drawLmk(MapFig,Lmk,MapOpt)

% DRAWLMK  Draw 3D landmark.
%   DRAWLMK(MapFig,Lmk) draws 3D landmark Lmk into the map figure by
%   updating the handles in MapFig structure. It accepts different types of
%   landmark by checking the field Lmk.type. Supported landmark types
%   (June 2009) are:
%       'idpPnt' - inverse depth points
%       'eucPnt' - Euclidean points
%       'hmgPnt' - homogeneous points.
%
%   DRAWLMK(...) draws mean and covariances of landmarks: 
%     - For punctual landmarks, the mean is a dot and the covariance is the
%       3/sigma ellipsoid. 
%     - For line landmarks, the mean is a segment between the two
%       landmark's endpoints, and the covariance is a 3-sigma ellipsoind at
%       each one of these endpoints.
%
%   See also DRAWIDPPNT, DRAWEUCPNT, DRAWHMGPNT.

%   (c) 2009 Joan Sola @ LAAS-CNRS.

switch (Lmk.type)

    % landmark types
    % --------------
    case {'idpPnt'}
        color = [1 0.5 0.5];
        drawIdpPnt(MapFig, Lmk, color);

    case {'eucPnt'}
        color = [.5 .5 1];
        drawEucPnt(MapFig, Lmk, color);

    case {'hmgPnt'}
        color = [1 0.5 0.5];
        drawHmgPnt(MapFig, Lmk, color);
        
    case {'plkLin'}
        color = [.8 .8 1];
        drawPlkLin(MapFig, Lmk, color, MapOpt);

    otherwise
        % TODO : print an error and go out
        error('??? Unknown landmark type ''%s''.',Lmk.type);

end
