function Frm = rob2frm(Rob, Frm)

% Creates a frame Frm from information in Rob.

global Map

Frm.rob = Rob.rob;
Frm.used = true;
% Frm.state.r % This is fixed by Frm structure.
Frm.state.x = Rob.state.x;
Frm.state.size = Rob.state.size;
% Frm.manifold.r % This is fixed by Frm structure.
Frm.manifold.x = Rob.manifold.x;
Frm.manifold.size = Rob.manifold.size;
Frm.manifold.active = true;

% Copy data to Map storage
Map.x(Frm.state.r) = Frm.state.x;
% Manifolds are zero until soving:
% Map.m(Frm.manifold.r) = Frm.manifold.x; 

