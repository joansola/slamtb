function Rob = frm2rob(Frm, Rob)

% Updates the robot Rob from information in Frm.

global Map

% Get info from Map
Frm.state.x = Map.x(Frm.state.r);
Frm.manifold.x = Map.x(Frm.manifold.r);

% Transfer to Rob
Rob.state.x = Frm.state.x;
Rob.manifold.x = Frm.manifold.x;


