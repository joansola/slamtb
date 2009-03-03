function [rt,RTc,RTk,RTli] = projectPluckerInRhoTheta(C,k,Li)

% PROJECTPLUCKERINRHOTHETA  Project Plucker line
%   PROJECTPLUCKERINRHOTHETA(C,K,Li)  projects the Plucker line Li into a camera with
%   intrinsic parameters K=[u0;v0;au;av] and at pose C=[t;q]. The resulting
%   line is coded in rho-theta.
%
%   [rt,RTc,RTk,RTli] = ... returns Jacobians wrt C, K and Li.
%
%   See also PROJECTPLUCKER

% (c) 2008 Joan Sola @ LAAS-CNRS

if nargout == 1

    rt = hm2rt(projectPlucker(C,k,Li));

else

    [l,Lc,Lk,Lli] = projectPlucker(C,k,Li);
    [rt,RTl] = hm2rt(l);
    
    RTc  = RTl*Lc;
    RTk  = RTl*Lk;
    RTli = RTl*Lli;

end

