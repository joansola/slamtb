function [po,Jv,Jp] = vp2p(v,pi)

% VP2P Rotate a point given rotation vector.
%   VP2P(P) is the point P rotated the amount indicated by the rotation
%   vector V.
%
%   [Po,Jv,Jp) = VP2P(Pi) provides the Jacobians of VP2P wrt. the rotation
%   vector V and the point Pi:
%
%     Jv = d(Po)/d(v) | v
%
%   and
%
%     Jp = d(Po)/d(Pi) | Pi
%
%   where | stands for 'evaluated at'.

R = v2R(v);
po = R*pi;

if nargout > 1
    % provide Jacobians
    p = v(1);
    q = v(2);
    r = v(3);
    x = pi(1);
    y = pi(2);
    z = pi(3);

    t1 = (p^2+q^2+r^2);
    t2 = t1^(1/2);
    t3 = t1^(3/2);
    t4 = -q^2/t1-p^2/t1;
    t5 = -r^2/t1-p^2/t1;
    t6 = -r^2/t1-q^2/t1;   
    
    s2 = sin(t2);
    c2 = cos(t2);
    d2 = 1-c2;


    Jv = [[   (s2*p/t2*t6+d2*(2*r^2/t1^2*p+2*q^2/t1^2*p))*x+(-c2/t1*p*r+s2*r/t3*p+s2*p^2/t3*q-2*d2*q/t1^2*p^2+d2*q/t1)*y+(c2/t1*p*q-s2*q/t3*p+s2*p^2/t3*r-2*d2*r/t1^2*p^2+d2*r/t1)*z,  (s2*q/t2*t6+d2*(2*r^2/t1^2*q-2*q/t1+2*q^3/t1^2))*x+(-c2/t1*q*r+s2*r/t3*q+s2*q^2/t3*p+d2/t1*p-2*d2*q^2/t1^2*p)*y+(c2/t1*q^2+s2/t2-s2*q^2/t3+s2*q/t3*r*p-2*d2*r/t1^2*p*q)*z,   (s2*r/t2*t6+d2*(-2*r/t1+2*r^3/t1^2+2*q^2/t1^2*r))*x+(-c2/t1*r^2-s2/t2+s2*r^2/t3+s2*q/t3*r*p-2*d2*r/t1^2*p*q)*y+(c2/t1*q*r-s2*r/t3*q+s2*r^2/t3*p+d2/t1*p-2*d2*r^2/t1^2*p)*z]
        [  (c2/t1*p*r-s2*r/t3*p+s2*p^2/t3*q-2*d2*q/t1^2*p^2+d2*q/t1)*x+(s2*p/t2*t5+d2*(2*r^2/t1^2*p-2*p/t1+2*p^3/t1^2))*y+(-c2/t1*p^2-s2/t2+s2*p^2/t3+s2*q/t3*r*p-2*d2*r/t1^2*p*q)*z,     (c2/t1*q*r-s2*r/t3*q+s2*q^2/t3*p+d2/t1*p-2*d2*q^2/t1^2*p)*x+(s2*q/t2*t5+d2*(2*r^2/t1^2*q+2*p^2/t1^2*q))*y+(-c2/t1*p*q+s2*q/t3*p+s2*q^2/t3*r-2*d2*r/t1^2*q^2+d2*r/t1)*z,   (c2/t1*r^2+s2/t2-s2*r^2/t3+s2*q/t3*r*p-2*d2*r/t1^2*p*q)*x+(s2*r/t2*t5+d2*(-2*r/t1+2*r^3/t1^2+2*p^2/t1^2*r))*y+(-c2/t1*p*r+s2*r/t3*p+s2*r^2/t3*q+d2*q/t1-2*d2*r^2/t1^2*q)*z]
        [  (-c2/t1*p*q+s2*q/t3*p+s2*p^2/t3*r-2*d2*r/t1^2*p^2+d2*r/t1)*x+(c2/t1*p^2+s2/t2-s2*p^2/t3+s2*q/t3*r*p-2*d2*r/t1^2*p*q)*y+(s2*p/t2*t4+d2*(2*q^2/t1^2*p-2*p/t1+2*p^3/t1^2))*z, (-c2/t1*q^2-s2/t2+s2*q^2/t3+s2*q/t3*r*p-2*d2*r/t1^2*p*q)*x+(c2/t1*p*q-s2*q/t3*p+s2*q^2/t3*r-2*d2*r/t1^2*q^2+d2*r/t1)*y+(s2*q/t2*t4+d2*(-2*q/t1+2*q^3/t1^2+2*p^2/t1^2*q))*z,     (-c2/t1*q*r+s2*r/t3*q+s2*r^2/t3*p+d2/t1*p-2*d2*r^2/t1^2*p)*x+(c2/t1*p*r-s2*r/t3*p+s2*r^2/t3*q+d2*q/t1-2*d2*r^2/t1^2*q)*y+(s2*r/t2*t4+d2*(2*q^2/t1^2*r+2*p^2/t1^2*r))*z]];
    
    Jp = R;

end
