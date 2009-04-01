
function [u, s, U_r, U_s, U_k, U_d, U_l] = ...
    projEucPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, l)

% PROJEUCPNTINTOPINHOLEONROB Project Euc pnt into pinhole on robot.
%    [U,S] = PROJEUCPNTINTOPINHOLEONROB(RF, SF, SPK, SPD, L) projects 3D
%    Euclidean points into a pin-hole camera mounted on a robot, providing
%    also the non-measurable depth. The input parameters are:
%       RF : robot frame
%       SF : pin-hole sensor frame in robot
%       SPK: pin-hole intrinsic parameters [u0 v0 au av]'
%       SPD: radial distortion parameters [K2 K4 K6 ...]'
%       L  : 3D point [x y z]'
%    The output parameters are:
%       U  : 2D pixel [u v]'
%       S  : nom-measurable depth
%
%    The function accepts a points matrix L = [L1 ... Ln] as input.
%    In this case, it returns a pixels matrix U = [U1 ... Un] and a depths
%    row-vector S = [S1 ... Sn].
%
%    [U,S,U_R,U_S,U_K,U_D,U_L] = ... gives also the jacobians of the
%    observation U wrt all input parameters. Note that this only works for
%    single points.
%
%    See also PINHOLE, TOFRAME.

if nargout <= 2 % only pixel

    lr    = toFrame(Rf,l);
    ls    = toFrame(Sf,lr);

    [u,s] = pinHole(ls,Spk,Spd);

else % Jacobians

    if size(l,2) == 1  % single point

        [lr, LR_r, LR_l]   = toFrame(Rf,l);
        [ls, LS_s, LS_lr]  = toFrame(Sf,lr);

        [u,s,U_ls,U_k,U_d] = pinHole(ls,Spk,Spd);

        U_r  = U_ls*LS_lr*LR_r;
        U_s  = U_ls*LS_s;
        U_lr = U_ls*LS_lr;
        U_l  = U_lr*LR_l;

    else
        error('??? Jacobians not available for multiple points.')

    end

end
return

%% test Jacobians - WARNING! IT TAKES AGES TO COMPUTE !!
syms rx ry rz ra rb rc rd sx sy sz sa sb sc sd u0 v0 au av d2 d4 d6 lx ly lz real

Rf.x=[rx;ry;rz;ra;rb;rc;rd];
Sf.x=[sx;sy;sz;sa;sb;sc;sd] ;

Rf = updateFrame(Rf);
Sf = updateFrame(Sf);
Spk = [u0;v0;au;av];
Spd = [d2;d4;d6];
l = [lx;ly;lz];

[u,s,U_r,U_s,U_k,U_d,U_l] = projEucPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, l);


simplify(U_r - jacobian(u,Rf.x))
simplify(U_s - jacobian(u,Sf.x))
simplify(U_k - jacobian(u,Spk))
simplify(U_d - jacobian(u,Spd))
simplify(U_l - jacobian(u,l))













