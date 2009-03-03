function [p,Pf,Ppf] = planeFromFrame(F,pF)

% PLANEFROMFRAME  Express in global frame a plane given in another frame
%   PLANEFROMFRAME(F,P_F) expresses in the global frame the plane P_F that
%   is given with respect to frame F. 
%
%   Planes in 3D are expressed in
%   homogeneous form and are therefore 4-vectors such that, for every
%   (homogeneous) point A of the plane, we have P'*A = 0.
%
%   Frames in 3D are expressed as 7-vectors containing the translation
%   vector and a quaternion for orientation.
%
%   [p,Pf,Ppf] = PLANEFROMFRAME(F,P_F) returns also the Jacobians of the
%   resulting plane wrt the frame vector F and the input plane P_F.
%
%   See also FROMFRAME, PLANETOFRAME

%   (c) 2008 Joan Sola @ LAAS-CNRS

t = F(1:3);
q = F(4:7);

R = q2R(q);

iHt = [R zeros(3,1);-t'*R 1];

p = iHt*pF;

if nargout > 1 % Jac
    
    Ppf = iHt;
    
    [x,y,z,a,b,c,d] = split(F);
    [px,py,pz,pw] = split(pF);

    Pt = [...
        [                                                         0,                                                         0,                                                         0]
        [                                                         0,                                                         0,                                                         0]
        [                                                         0,                                                         0,                                                         0]
        [ (-a^2-b^2+c^2+d^2)*px+(-2*b*c+2*a*d)*py+(-2*b*d-2*a*c)*pz, (-2*b*c-2*a*d)*px+(-a^2+b^2-c^2+d^2)*py+(-2*c*d+2*a*b)*pz, (-2*b*d+2*a*c)*px+(-2*c*d-2*a*b)*py+(-a^2+b^2+c^2-d^2)*pz]];

    Pq = [...
        [                                                    2*a*px-2*d*py+2*c*pz,                                                    2*b*px+2*c*py+2*d*pz,                                                   -2*c*px+2*b*py+2*a*pz,                                                   -2*d*px-2*a*py+2*b*pz]
        [                                                    2*d*px+2*a*py-2*b*pz,                                                    2*c*px-2*b*py-2*a*pz,                                                    2*b*px+2*c*py+2*d*pz,                                                    2*a*px-2*d*py+2*c*pz]
        [                                                   -2*c*px+2*b*py+2*a*pz,                                                    2*d*px+2*a*py-2*b*pz,                                                   -2*a*px+2*d*py-2*c*pz,                                                    2*b*px+2*c*py+2*d*pz]
        [  (-2*x*a-2*y*d+2*z*c)*px+(2*x*d-2*y*a-2*z*b)*py+(-2*x*c+2*y*b-2*z*a)*pz, (-2*x*b-2*y*c-2*z*d)*px+(-2*x*c+2*y*b-2*z*a)*py+(-2*x*d+2*y*a+2*z*b)*pz,  (2*x*c-2*y*b+2*z*a)*px+(-2*x*b-2*y*c-2*z*d)*py+(-2*x*a-2*y*d+2*z*c)*pz,   (2*x*d-2*y*a-2*z*b)*px+(2*x*a+2*y*d-2*z*c)*py+(-2*x*b-2*y*c-2*z*d)*pz]
        ];
    Pf = [Pt Pq];
    
end

return

%% jac

syms x y z a b c d px py pz pw real
pF = [px;py;pz;pw];
t  = [x;y;z];
q  = [a;b;c;d];

F  = [t;q];

p = planeFromFrame(F,pF);

Pt = jacobian(p,t)
Pq = subexpr(jacobian(p,q))

%%
[p,Pf,Ppf] = planeFromFrame(F,pF);
Pf - jacobian(p,F)
Ppf - jacobian(p,pF)
