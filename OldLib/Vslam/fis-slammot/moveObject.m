function Obj = moveObject(Obj,Ts)

% Obj = moveObject(Obj,Ts)

if nargin < 2, Ts = 1; end

[Obj.x,Fx,Fu] = constVel(Obj.x,Ts,Obj.w);

Obj.P = Fx*Obj.P*Fx' + Fu*Obj.W*Fu';
