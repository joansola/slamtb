function [L,Lt,Le,Lk,Ll,Lb] = retroProjectPluckerEuler(t,e,k,l,b)

if nargout == 1

    LC = invPinHolePlucker(k,l,b);

    L = fromFramePluckerEuler(t,e,LC);

else

    [LC,LCk,LCl,LCb] = invPinHolePlucker(k,l,b);
    
    [L,Lt,Le,Llc] = fromFramePluckerEuler(t,e,LC);

    Lk  = Llc*LCk;
    Ll  = Llc*LCl;
    Lb  = Llc*LCb;

    LRlc = Llc
    LRr = [Lt Le]
    
end

return

%%

syms a b c x y z real
syms L1 L2 L3 L4 L5 L6 real
syms u0 v0 au av real
syms l1 l2 l3 beta1 beta2 real

e = [a;b;c];
t = [x;y;z];
k = [u0 v0 au av];
l = [l1;l2;l3];
beta = [beta1;beta2];

[L,Lt,Le,Lk,Ll,Lb] = retroProjectPluckerEuler(t,e,k,l,beta);

simplify(Lt - jacobian(L,t))
%%
simplify(Le - jacobian(L,e))
%%
simplify(Lk - jacobian(L,k))
%%
simplify(Ll - jacobian(L,l))
%%
simplify(Lb - jacobian(L,beta))

