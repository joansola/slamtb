function Rob = matchRobMap(Rob)

% MATCHROBMAP  Normalize robot quaternion and update frame from Map info.

global Map

% normalize quaternion
qr          = Rob.r(4:7);      % quaternion range in map
[qn,QNq]    = normquat(Map.X(qr));
Map.X(qr)   = qn;
Map.P(qr,:) = QNq*Map.P(qr,:); % Affect Covariances with Jacobian of normalization
Map.P(:,qr) = Map.P(:,qr)*QNq; % QNq is symmetric. It should be QNq' otherwise


% Update Rob info to match that in the map
Rob.X       = Map.X(Rob.r);
Rob         = updateFrame(Rob);

Rob.V       = Map.X(Rob.vr);
