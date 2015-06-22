function Frm = updateKeyFrm(Frm)

global Map

% Get state error from Map
dvp = Map.x(Frm.state.r);
Frm.state.dx = dvp;

% Get nominal state from Frm
F.x(1:7,1) = Frm.state.x;
F = updateFrame(F);

% Pose error as a PQ pose
dF.x(1:7,1) = vpose2qpose(dvp);
dF = updateFrame(dF);

% Pose update
F = composeFrames(dF, F);

% Update Frm structure
Frm.state.x = F.x;

