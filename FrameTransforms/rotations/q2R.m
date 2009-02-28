function [R,Rq] = q2R(q)

% Q2R  Quaternion to rotation matrix conversion.
%   R = Q2R(Q) builds the rotation matrix corresponding to the unit
%   quaternion Q. The obtained matrix R is such that the product:
%
%        re = R * rb 
%
%   converts the body referenced vector  rb 
%      into the earth referenced vector  re
%
%   [R,Rq] = (...) returns the Jacobian wrt q.

a  = q(1);
b  = q(2);
c  = q(3);
d  = q(4);

a2 = a^2;
ab = 2*a*b;
ac = 2*a*c;
ad = 2*a*d;
b2 = b^2;
bc = 2*b*c;
bd = 2*b*d;
c2 = c^2;
cd = 2*c*d;
d2 = d^2;

R  = [...
    a2+b2-c2-d2    bc-ad          bd+ac
    bc+ad          a2-b2+c2-d2    cd-ab
    bd-ac          cd+ab          a2-b2-c2+d2];

  
if nargout > 1
    
    [aa,bb,cc,dd] = deal(2*a,2*b,2*c,2*d);
    
    Rq = [...
        [  aa,  bb, -cc, -dd]
        [  dd,  cc,  bb,  aa]
        [ -cc,  dd, -aa,  bb]
        [ -dd,  cc,  bb, -aa]
        [  aa, -bb,  cc, -dd]
        [  bb,  aa,  dd,  cc]
        [  cc,  dd,  aa,  bb]
        [ -bb, -aa,  dd,  cc]
        [  aa, -bb, -cc,  dd]];
    
end

