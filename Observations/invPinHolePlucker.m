function [L,Lk,Ll,Lbeta] = invPinHolePlucker(k,l,beta)

% INVPINHOLEPLUCKER Retro-projects plucker line
%   INVPINHOLEPLUCKER(K,L,BETA) retro-projects the Plucker line L from a
%   pin hole camera K=[u0;v0;au;av] at the origin. BETA specifies the
%   unobservable direction of the line. BETA is a 2-vector expressed in the
%   plane base given by PLANEVEC2PLANEBASE.
%
%   [l,Lk,Ll,Lbeta] = ... returns Jacobians wrt K, L and BETA.
%
%   See also PLANEVEC2PLANEBASE, PLANEBASE2DIRVECTOR.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin < 3
    beta = [1;0];
end

if nargout == 1

    an = aInvPinHolePlucker(k,l); % sub-vector A defines the plane

    a  = normvec(an,1); % normalize

    b = planeBase2dirVector(a,beta); % sub-vector b defines the line direction

    L = [a;b];  % Plucker Line

else % jacobians

    [an,ANk,ANl] = aInvPinHolePlucker(k,l); % sub-vector A defines the plane
    [a,Aan]      = normvec(an,0);
    [b,Ba,Bbeta] = planeBase2dirVector(a,beta);

    Ak    = Aan*ANk;
    Al    = Aan*ANl;
    Abeta = zeros(3,2);
    
    Bk    = Ba*Ak;
    Bl    = Ba*Al;
    % Bbeta is already defined

    L     = [a;b];

    Lk    = [Ak;Bk];
    Ll    = [Al;Bl];
    Lbeta = [Abeta;Bbeta];
    
%     Aan
%     ANl
%     LCa = [eye(3);Ba]

end

return

%%
syms u0 v0 au av a b c b1 b2 real

k    = [u0 v0 au av]';
l    = [a;b;c];
beta = [b1;b2];

[L,Lk,Ll,Lbeta] = invPinHolePlucker(k,l,beta);
% L = invPinHolePlucker(k,l,beta);

simplify(Lk    - jacobian(L,k))
simplify(Ll    - jacobian(L,l))
simplify(Lbeta - jacobian(L,beta))











