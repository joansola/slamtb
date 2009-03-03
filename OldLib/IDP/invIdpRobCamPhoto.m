function [idp,IDPr,IDPc,IDPpx,IDPrho] = invIdpRobCamPhoto(Rob,Cam,pix,rho)

[x0,X0r,X0ct] = fromFrame(Rob,Cam.t);

[p,Pr,Pc,Ppx] = invRobCamPhoto(Rob,Cam,pix,1); % point at 1m depth
m         = p-x0;
[py,PYm]  = vec2py(m);   % global direction angles
idp       = [x0;py;rho];

if nargout > 1 % we want Jacobians
    
    X0c    = [X0ct zeros(3,4)];
    Mp  = 1;  %  eye(3);
    Mx0 = -1; % -eye(3);

    PYr    = PYm*(Mp*Pr+Mx0*X0r);
    PYc    = PYm*(Mp*Pc+Mx0*X0c);
    PYpx   = PYm*Mp*Ppx;

    RHOrho = 1;
    
    IDPr   = [X0r;        PYr;  zeros(1,7)];
    IDPc   = [X0c;        PYc;  zeros(1,7)];
    IDPpx  = [zeros(3,2); PYpx; zeros(1,2)];
    IDPrho = [    zeros(5,1);   RHOrho    ];

end

return

%% Test jacobians 
% Proceed by debugging step by step and checking that variables take the
% right names here and there. Result is huge and is not printed by Matlab
% 

syms a b c d x y z ac bc cc dc xc yc zc u v r real
syms u0 v0 au av k2 k4 k6 real

Rob.X = [x;y;z;a;b;c;d];
cam.X = [xc;yc;zc;ac;bc;cc;dc];
cam.cal = [u0;v0;au;av];
cam.undist = [k2;k4;k6];
Rob = updateFrame(Rob);
cam = updateFrame(cam);
pix = [u;v];
rho = r;

[idp,IDPr,IDPc,IDPpx,IDPrho] = invIdpRobCamPhoto(Rob,cam,pix,rho);

