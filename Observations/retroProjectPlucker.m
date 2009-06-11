function [L,Lc,Lk,Ll,Lbeta] = retroProjectPlucker(C,k,l,beta)

% RETROPROJECTPLUCKER  Retro project Plucker line
%   L = RETROPROJECTPLUCKER(C,K,l,beta) retro-projects the line l perceived
%   in a camera with intrinsic parameters K at frame C, using the
%   unobservable director vector beta, defined in the plane containing the
%   measured line l and the camera origin.
%
%   [L,Lc,Lk,Ll,Lbeta] = ... returns the Jacobians wrt C, K, l and beta.

% (c) 2008 Joan Sola @ LAAS-CNRS

if nargout == 1

    LC = invPinHolePlucker(k,l,beta); % the line in C frame

    L = fromFramePlucker(C,LC); % the line in global frame

else

    [LC,LCk,LCl,LCbeta] = invPinHolePlucker(k,l,beta);

    [L,Lc,Llc] = fromFramePlucker(C,LC);

    Lk  = Llc*LCk;
    Ll  = Llc*LCl;
    Lbeta = Llc*LCbeta;

end

return

%%

syms a b c d x y z real
syms L1 L2 L3 L4 L5 L6 real
syms u0 v0 au av real
syms l1 l2 l3 beta1 beta2 real

q = [a;b;c;d];
t = [x;y;z];
C = [t;q];
k = [u0 v0 au av];
l = [l1;l2;l3];
beta = [beta1;beta2];

[L,Lc,Lk,Ll,Lbeta] = retroProjectPlucker(C,k,l,beta);

%% caution - very slow symbolic calculus (some minutes)
simplify(Lc - jacobian(L,C))
simplify(Lk - jacobian(L,k))
simplify(Ll - jacobian(L,l))
simplify(Lbeta - jacobian(L,beta))
