function Obj = estimateObject(Rob,Obj)


global WDIM

R = Rob.R;
t = Rob.t;

rr = 1:WDIM;
vr = WDIM+rr;

r = Obj.x(rr);
v = Obj.x(vr);
Pr = Obj.P(rr,rr);

rW = R*r+t;
vW = R*v;

Obj.xW  = [rW;vW];
Obj.PrW = R*Pr*R';
