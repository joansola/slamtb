function [aL,aLc,aLk,aLl,aLbeta] = retroProjectAPlucker(C,k,l,beta)

% RETROPROJECTPLUCKER  Retro project Plucker line
%   L = RETROPROJECTPLUCKER(C,K,l,beta) retro-projects the line l perceived
%   in a camera with intrinsic parameters K at frame C, using the
%   unobservable director vector beta, defined in the plane containing the
%   measured line l and the camera origin.
%
%   [L,Lc,Lk,Ll,Lbeta] = ... returns the Jacobians wrt C, K, l and beta.

% (c) 2008 Joan Sola @ LAAS-CNRS

%MAYBE THIS SHOULD BE CORRECTED!!!! USING FROMFRAMEAPLUCKER

if nargout == 1

    L = retroProjectPlucker(C,k,l,beta);
    aL = anchorPlucker(L,C(1:3));
   
else

    [L,Lc,Lk,Ll,Lbeta] = retroProjectPlucker(C,k,l,beta);
    [aL,AL_l,AL_x] = anchorPlucker(L,C(1:3));


    aLc= AL_x*Lc(1:3,1:7);
    aLk  = AL_l*Lk;
    aLl  = AL_l*Ll;
    aLbeta = AL_l*Lbeta;

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

[L,Lc,Lk,Ll,Lbeta] = retroProjectAPlucker(C,k,l,beta);

% caution - very slow symbolic calculus (some minutes)
simplify(Lc - jacobian(L,C))
simplify(Lk - jacobian(L,k))
simplify(Ll - jacobian(L,l))
simplify(Lbeta - jacobian(L,beta))
