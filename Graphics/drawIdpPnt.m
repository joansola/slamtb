function drawIdpPnt(MapFig, Lmk, color)

% DRAWIDPPNT  Draw inverse-depth point landmark in MapFig.

global Map

posOffset = [0;0;.2];

% idp
idp = Map.x(Lmk.state.r) ;
IDP = Map.P(Lmk.state.r,Lmk.state.r) ;

% Euclidean
[x,P] = propagateUncertainty(idp,IDP,@idp2p);

% draw
drawGauss3dPnt(MapFig.Lmk(Lmk.lmk),x,P,num2str(Lmk.id),color,posOffset);
