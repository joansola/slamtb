function [u, s, U_r, U_s, U_k, U_d, U_l] = ...
    projHmgPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, l)


%
% TODO
% 

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
%       S  : non-measurable depth
%
%    The function accepts a points matrix L = [L1 ... Ln] as input.
%    In this case, it returns a pixels matrix U = [U1 ... Un] and a depths
%    row-vector S = [S1 ... Sn].
%
%    [U,S,U_R,U_S,U_K,U_D,U_L] = ... gives also the jacobians of the
%    observation U wrt all input parameters. Note that this only works for
%    single points.
%
%    See also PINHOLE, TOFRAME, PROJIDPPNTINTOPINHOLEONROB.

%   (c) 2009 David Marquez @ LAAS-CNRS.

if nargout <= 2 % only pixel
    
    % landmark position in euclidian space:
    leucl = hmg2p(l) ;
    
    % projection in euclidian space
    [u,s] = projEucPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, leucl) ;
        
else % Jacobians
    
    % landmark position in euclidian space:
    [leucl, LEUCLl] = hmg2euc(l) ;
    
    if size(l,2) == 1  % single point
        
        % projection in euclidian space
        [u, s, U_r, U_s, U_k, U_d, U_leucl] = projEucPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, leucl) ;
        
        % jacobian return in Hmg space
        U_l = U_leucl*LEUCLl ;
        
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













