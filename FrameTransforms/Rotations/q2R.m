function [R,Rq] = q2R(q)

% Q2R  Quaternion to rotation matrix conversion.
%   R = Q2R(Q) builds the rotation matrix corresponding to the unit
%   quaternion Q. The obtained matrix R is such that the product:
%
%        rg = R * rb 
%
%   converts the body referenced vector  rb 
%     into the global referenced vector  rg
%
%   [R,Rq] = (...) returns the Jacobian wrt q.
%
%   See also QUATERNION, R2Q, Q2E, Q2V.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

[a,b,c,d] = split(q);

aa = a^2;
ab = 2*a*b;
ac = 2*a*c;
ad = 2*a*d;
bb = b^2;
bc = 2*b*c;
bd = 2*b*d;
cc = c^2;
cd = 2*c*d;
dd = d^2;

R  = [...
    aa+bb-cc-dd    bc-ad          bd+ac
    bc+ad          aa-bb+cc-dd    cd-ab
    bd-ac          cd+ab          aa-bb-cc+dd];

  
if nargout > 1
    
    [a2,b2,c2,d2] = deal(2*a,2*b,2*c,2*d);
    
    Rq = [...
        [  a2,  b2, -c2, -d2]
        [  d2,  c2,  b2,  a2]
        [ -c2,  d2, -a2,  b2]
        [ -d2,  c2,  b2, -a2]
        [  a2, -b2,  c2, -d2]
        [  b2,  a2,  d2,  c2]
        [  c2,  d2,  a2,  b2]
        [ -b2, -a2,  d2,  c2]
        [  a2, -b2, -c2,  d2]];
    
end










