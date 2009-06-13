function [aL,aL_c,aL_k,aL_hm,aL_beta] = retroProjectAPlucker(C,k,hm,beta)

% RETROPROJECTAPLUCKER  Retro project to anchored Plucker line
%   L = RETROPROJECTAPLUCKER(C,K,hm,beta) retro-projects the 2d homogeneous
%   line hm perceived in a camera with intrinsic parameters K at frame C,
%   using the unobservable director vector beta, defined in the plane
%   containing the measured line hm and the camera origin.
%
%   [L,L_c,L_k,L_hm,L_beta] = ... returns the Jacobians wrt C, K, hm and beta.

% (c) 2009 Joan Sola @ LAAS-CNRS

if nargout == 1

    L  = retroProjectPlucker(C,k,hm,beta);
    aL = anchorPlucker(L,C(1:3));
   
else

    [L,L_c,L_k,L_hm,L_beta] = retroProjectPlucker(C,k,hm,beta);
    [aL,AL_l,AL_x] = anchorPlucker(L,C(1:3));


    aL_c    = AL_x*L_c(1:3,:);
    aL_k    = AL_l*L_k;
    aL_hm   = AL_l*L_hm;
    aL_beta = AL_l*L_beta;

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
hm = [l1;l2;l3];
beta = [beta1;beta2];

[L,L_c,L_k,L_hm,L_beta] = retroProjectAPlucker(C,k,hm,beta);

%% caution - very slow symbolic calculus (some minutes)
simplify(L_c - jacobian(L,C))
simplify(L_k - jacobian(L,k))
simplify(L_hm - jacobian(L,hm))
simplify(L_beta - jacobian(L,beta))
