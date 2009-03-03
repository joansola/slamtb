
% TEST to delete
I3 = eye(3);
I2 = eye(2);
I20 = [I2 [0;0];0 0 0];
Z3 = zeros(3);

vObj(1).x = [6;-2;0;0;.2;0];
vObj(1).Pv = .1*I20;
vObj(1).w = zeros(3,1);
vObj(1).W = .001*I3;

vObj(2).x = [10;-4;0;-.2;.2;0];
vObj(2).Pv = .1*I20;
vObj(2).w = zeros(3,1);
vObj(2).W = .001*I3;

vObj(3).x = [8;0;0;-.2;0;0];
vObj(3).Pv = .1*I20;
vObj(3).w = zeros(3,1);
vObj(3).W = .001*I3;


vObj(4).x = [3;0;0;0;0;.05];
vObj(4).Pv = .1*I3;
vObj(4).w = zeros(3,1);
vObj(4).W = .001*I3;

%  static objects
vObj(1).x = [8.17;-.53;.244;0;0;0];
vObj(1).Pv = .1*I20;
vObj(1).w = zeros(3,1);
vObj(1).W = .001*I3;

vObj(2).x = [10.15;-.163;.31;0;0;0];
vObj(2).Pv = .1*I20;
vObj(2).w = zeros(3,1);
vObj(2).W = .001*I3;



