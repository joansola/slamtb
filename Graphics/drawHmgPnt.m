function drawHmgPnt(MapFig, Lmk, color)

% DRAWHMGPNT  Draw Homogeneous point landmark in MapFig.

global Map

posOffset = [0;0;.2];

% Homogeneous
hmg = Map.x(Lmk.state.r) ;
HMG = Map.P(Lmk.state.r,Lmk.state.r) ;

% Euclidean
[x,P] = propagateUncertainty(hmg,HMG,@hmg2euc);

% draw
drawGauss3dPnt(MapFig.Lmk(Lmk.lmk),x,P,num2str(Lmk.id),color,posOffset);
