function drawIdpPnt(MapFig, Lmk, color, MapOpt)

% DRAWIDPPNT  Draw inverse-depth point landmark in MapFig.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

posOffset = [0;0;.2];

% transform to Euclidean
[x,P] = propagateUncertainty(       ...
    Map.x(Lmk.state.r),             ...
    Map.P(Lmk.state.r,Lmk.state.r), ...
    @idp2euc);

% draw
drawPnt    (MapFig.Lmk(Lmk.lmk).mean,    x,    color.mean)
if MapOpt.showEllip
    drawEllipse(MapFig.Lmk(Lmk.lmk).ellipse, x, P, color.ellip)
end
drawLabel  (MapFig.Lmk(Lmk.lmk).label,   x+posOffset, num2str(Lmk.id))









