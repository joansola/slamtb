function drawAhmLin(MapFig,Lmk,color,MapOpt)

% DRAWAHMLIN  Draw anchored homogenous line landmark in MapFig.

%   Copyright 2009 Teresa Vidal.

global Map

% get the lmk from the Map
r   = Lmk.state.r;       % range in Map
idl = Map.x(r);          % mean
IDL = Map.P(r,r);        % covariances matrix
t   = [Lmk.par.endp.t]'; % abscissas of endpoints, t = [t1;t2]

% extract two endpoints - means and covariance
[e1,e2,E1_idl,E2_idl] = ahmLinEndpoints(idl,t(1),t(2)); % means and Jacobians
E1 = E1_idl*IDL*E1_idl'; % covariances
E2 = E2_idl*IDL*E2_idl';

% draw the mean:
drawSeg(MapFig.Lmk(Lmk.lmk).mean,[e1;e2],color.mean)

% draw the covariance ellipses
if MapOpt.showEllip
    drawEllipse(MapFig.Lmk(Lmk.lmk).ellipse(1), e1, E1, color.ellip)
    drawEllipse(MapFig.Lmk(Lmk.lmk).ellipse(2), e2, E2, color.ellip)
end

% draw the label
e = e2-e1;
n = null([e e e]); 
n = n(:,2)*sign(n(3,2)); % Inverse depth line's normal vector
posOffset = 0.2*n;     % label orthogonally out of the line.
drawLabel(MapFig.Lmk(Lmk.lmk).label,0.5*(e1+e2) + posOffset,num2str(Lmk.id))









