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
        colors = MapOpt.colors.othPnt;
        drawIdpPnt(MapFig, Lmk, colors);

    case {'eucPnt'}
        colors = MapOpt.colors.eucPnt;
        drawEucPnt(MapFig, Lmk, colors);

    case {'hmgPnt'}
        colors = MapOpt.colors.othPnt;
        drawHmgPnt(MapFig, Lmk, colors);
        
    case {'plkLin'}
        colors = MapOpt.colors.plkLin;
        drawPlkLin(MapFig, Lmk, colors, MapOpt);
        
    case {'aplLin'}
        colors = MapOpt.colors.plkLin;
        drawAplLin(MapFig, Lmk, colors, MapOpt);
        

    otherwise
        % TODO : print an error and go out
        error('??? Unknown landmark type ''%s''.',Lmk.type);

end
