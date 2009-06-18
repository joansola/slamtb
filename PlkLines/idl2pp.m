function [p1,p2] = idl2pp(idl)

% IDL2PP Inverse depth line to passage points.
%   [P1,P2] = IDL2PP(IDL)  converts the inverse depth line IDL into two
%   passage points P1 and P2.

p0 = idl(1:3);
m1 = idl(4:5);
r1 = idl(6);
m2 = idl(7:8);
r2 = idl(9);

p1 = p0+py2vec(m1)/r1;
p2 = p0+py2vec(m2)/r2;

