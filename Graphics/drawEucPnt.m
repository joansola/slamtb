function drawEucPnt(MapFig, Lmk, color)

% DRAWEUCPNT  Draw Euclidean point landmark in MapFig.

global Map

posOffset = [0;0;.2];

% Mean and covariance
x = Map.x( Lmk.state.r);
P = Map.P(Lmk.state.r,Lmk.state.r);

drawGauss3dPnt(MapFig.Lmk(Lmk.lmk), x, P, color, num2str(Lmk.id), posOffset);

