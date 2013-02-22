function [u, s, U_r, U_s, U_k, U_d, U_l] = ...
    projEucPntIntoOmniCamOnRob(Rf, Sf, Spk, Spd, l)

% PROJEUCPNTINTOOMNICAMONROB Project Euc pnt into omnidirec cam on robot.
%    [U,S] = PROJEUCPNTINTOOMNICAMONROB(RF, SF, SPK, SPD, L) projects 3D
%    Euclidean points into a omni-cam camera mounted on a robot, providing
%    also the non-measurable depth. The input parameters are:
%       RF : robot frame
%       SF : omni-cam sensor frame in robot
%       SPK: omni-cam intrinsic parameters [xc yc c d e]'
%       SPD: radial distortion polynom [a0 a1 a2 ...]'
%       L  : 3D point [x y z]'
%    The output parameters are:
%       U  : 2D pixel [u v]'
%       S  : non-measurable depth
%
%    The function accepts a points matrix     L = [L1 ... Ln] as input.
%    In this case, it returns a pixels matrix U = [U1 ... Un] and a depths
%    row-vector S = [S1 ... Sn].
%
%    [U,S,U_R,U_S,U_K,U_D,U_L] = ... gives also the jacobians of the
%    observation U wrt all input parameters. Note that this only works for
%    single points.
%
%    See also OMNICAM, TOFRAME.

%   Copyright 2012 Grigory Abuladze @ ASL-vision
%   Copyright 2009 David Marquez    @ LAAS-CNRS.

if nargout <= 2 % only pixel
    
    lr    = toFrame(Rf,l);
    ls    = toFrame(Sf,lr);
    
    [u,s] = omniCam(ls,Spk,Spd);
    
else % Jacobians
    
    if size(l,2) == 1  % single point
        
        % Same functions with Jacobians
        [lr, LR_r, LR_l]   = toFrame(Rf,l);
        [ls, LS_s, LS_lr]  = toFrame(Sf,lr);
        [u,s,U_ls,U_k,U_d] = omniCam(ls,Spk,Spd);
        
        % The chain rule for Jacobians
        U_lr = U_ls*LS_lr;
        U_r  = U_lr*LR_r;
        U_s  = U_ls*LS_s;
        U_l  = U_lr*LR_l;
        
    else
        error('??? Jacobians not available for multiple points.')
        
    end
    
end
return

%% test Jacobians - WARNING! IT TAKES AGES TO COMPUTE !!
syms rx ry rz ra rb rc rd sx sy sz sa sb sc sd lx ly lz real

syms a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 real  % proj 10th order polynom in our case
syms xc yc cc dd ee real

Rf.x=[rx;ry;rz;ra;rb;rc;rd];
Sf.x=[sx;sy;sz;sa;sb;sc;sd] ;

Rf = updateFrame(Rf);
Sf = updateFrame(Sf);
Spk = [xc yc cc dd ee]';                      % omni-cam "calibration"
Spd = [a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10]';   % omni-cam "ditortion"
l = [lx;ly;lz];

[u,s,U_r,U_s,U_k,U_d,U_l] = projEucPntIntoOmniCamOnRob(Rf, Sf, Spk, Spd, l);


simplify(U_r - jacobian(u,Rf.x))
simplify(U_s - jacobian(u,Sf.x))
simplify(U_k - jacobian(u,Spk))
simplify(U_d - jacobian(u,Spd))
simplify(U_l - jacobian(u,l))






















