function drawIdpPnt(MapFig, Lmk, color)

% DRAWIDPPNT  Draw inverse-depth point landmark in MapFig.

global Map

posOffset = [0;0;.2];

% transform to Euclidean
[x,P] = propagateUncertainty(       ...
    Map.x(Lmk.state.r),             ...
    Map.P(Lmk.state.r,Lmk.state.r), ...
    @idp2p);

% draw
drawGauss3dPnt(MapFig.Lmk(Lmk.lmk),x,P,color,num2str(Lmk.id),posOffset);
