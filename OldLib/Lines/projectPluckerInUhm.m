function [u,Uc,Uk,Uli] = projectPluckerInUhm(C,k,Li)

% PROJECTPLUCKERINUHM  Project Plucker line
%   PROJECTPLUCKERINUHM(C,K,Li)  projects the Plucker line Li into a camera with
%   intrinsic parameters K=[u0;v0;au;av] and at pose C=[t;q]. The resulting
%   line is coded in unit homogeneous coordinates.
%
%   [rt,Uc,Uk,Uli] = ... returns Jacobians wrt C, K and Li.
%
%   See also PROJECTPLUCKER

% (c) 2008 Joan Sola @ LAAS-CNRS

if nargout == 1

    u = normvec(projectPlucker(C,k,Li));

else

    [l,Lc,Lk,Lli] = projectPlucker(C,k,Li);
    [u,Ul] = normvec(l);
    
    Uc  = Ul*Lc;
    Uk  = Ul*Lk;
    Uli = Ul*Lli;

end

