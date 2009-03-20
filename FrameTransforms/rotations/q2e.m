function [e,Eq] = q2e(q)

% Q2E  Quaternion to Euler angles conversion.
%   Q2E(Q) returns an Euler angles vector corresponding to orientation Q.
%
%   [E,Jq] = Q2E(Q) returns also the Jacobian matrix.
%
%   See also QUATERNION, R2Q, E2Q, Q2V.

%   (c) 2009 Joan Sola @ LAAS-CNRS.



a  = q(1);
b  = q(2);
c  = q(3);
d  = q(4);

y1 =  2*c*d + 2*a*b;
x1 =  a^2   - b^2   - c^2 + d^2;
z2 = -2*b*d + 2*a*c;
y3 =  2*b*c + 2*a*d;
x3 =  a^2   + b^2   - c^2 - d^2;

w  = whos('q');

if strcmp(w.class,'sym')
    
    e = [ atan(y1/x1)
          asin(z2)
          atan(y3/x3) ];
      
else
    
    e = [ atan2(y1,x1)
          asin(z2)
          atan2(y3,x3) ];
      
end

if nargout >1 
    
    dx1dq  = [ 2*a, -2*b, -2*c,  2*d];
    dy1dq  = [ 2*b,  2*a,  2*d,  2*c];
    dz2dq  = [ 2*c, -2*d,  2*a, -2*b];
    dx3dq  = [ 2*a,  2*b, -2*c, -2*d];
    dy3dq  = [ 2*d,  2*c,  2*b,  2*a];
    
    de1dx1 = -y1/(x1^2 + y1^2);
    de1dy1 =  x1/(x1^2 + y1^2);
    de2dz2 =   1/sqrt(1-z2^2);
    de3dx3 = -y3/(x3^2 + y3^2);
    de3dy3 =  x3/(x3^2 + y3^2);
    
    de1dq  = de1dx1*dx1dq + de1dy1*dy1dq;
    de2dq  = de2dz2*dz2dq;
    de3dq  = de3dx3*dx3dq + de3dy3*dy3dq;
    
    Eq     = [de1dq;de2dq;de3dq];
end

return

%% jac

syms a b c d real
q=[a;b;c;d];
[e,Eq] = q2e(q);
simplify(Eq-jacobian(e,q))
