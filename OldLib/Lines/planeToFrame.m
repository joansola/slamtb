function [pF,PFf,PFp] = planeToFrame(F,p)

% PLANETOFRAME  Express in the given frame a plane given in global frame.
%   PLANETOFRAME(F,P) expresses in frame F the plane P that is given with
%   respect to the global frame.
%
%   Planes in 3D are expressed in homogeneous form and are therefore
%   4-vectors such that, for every (homogeneous) point A of the plane, we
%   have P'*A = 0.
%
%   Frames in 3D are expressed as 7-vectors containing the translation
%   vector and a quaternion for orientation.
%
%   [pF,PFf,PFp] = PLANETOFRAME(F,P) returns also the Jacobians of the
%   resulting plane wrt the frame vector F and the input plane P.
%
%   See also TOFRAME, PLANEFROMFRAME

%   (c) 2008 Joan Sola @ LAAS-CNRS

t = F(1:3);
q = F(4:7);

R = q2R(q);

Ht = [R' zeros(3,1);t' 1];

pF = Ht*p;

if nargout > 1 % Jac

    PFp = Ht;

    [x,y,z,a,b,c,d] = split(F);
    [px,py,pz,pw] = split(p);

    PFt = [...
        [  0,  0,  0]
        [  0,  0,  0]
        [  0,  0,  0]
        [ px, py, pz]];

    PFq = [...
        [  2*a*px+2*d*py-2*c*pz,  2*b*px+2*c*py+2*d*pz, -2*c*px+2*b*py-2*a*pz, -2*d*px+2*a*py+2*b*pz]
        [ -2*d*px+2*a*py+2*b*pz,  2*c*px-2*b*py+2*a*pz,  2*b*px+2*c*py+2*d*pz, -2*a*px-2*d*py+2*c*pz]
        [  2*c*px-2*b*py+2*a*pz,  2*d*px-2*a*py-2*b*pz,  2*a*px+2*d*py-2*c*pz,  2*b*px+2*c*py+2*d*pz]
        [                     0,                     0,                     0,                     0]];

    PFf = [PFt PFq];

end

return

%% jac

syms x y z a b c d px py pz pw real
p  = [px;py;pz;pw];
t  = [x;y;z];
q  = [a;b;c;d];

F  = [t;q];

%%
pF = planeToFrame(F,p);

PFt = jacobian(pF,t)
PFq = subexpr(jacobian(pF,q))

%%
[pF,PFf,PFp] = planeToFrame(F,p);

PFf - jacobian(pF,F)
PFp - jacobian(pF,p)