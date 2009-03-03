function [lo,LOt,LOe,LOk,LOli] = projectPluckerEuler(t,e,k,Li)

if nargout == 1

    L  = toFramePluckerEuler(t,e,Li);

    lo = pinHolePlucker(k,L);
    
else
    
    [L,Lt,Le,Lli] = toFramePluckerEuler(t,e,Li);

    [lo,LOk,LOl]  = pinHolePlucker(k,L);

    LOt  = LOl*Lt;
    LOe  = LOl*Le;
    LOli = LOl*Lli;

end



return

%%

syms a b c x y z real
syms L1 L2 L3 L4 L5 L6 real
syms u0 v0 au av real

t = [x;y;z];
q = [a;b;c];

k = [u0 v0 au av];
Li = [L1 L2 L3 L4 L5 L6]';

[lo,LOt,LOe,LOk,LOli] = projectPluckerEuler(t,e,k,Li);

simplify(LOt - jacobian(lo,t))
simplify(LOe - jacobian(lo,e))
simplify(LOk - jacobian(lo,k))
simplify(LOli - jacobian(lo,Li))


