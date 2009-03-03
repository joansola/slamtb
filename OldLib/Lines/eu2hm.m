function [h,He] = eu2hm(e)

h = [e;1];

if nargout > 1 % Jac -- OK
    
    He = [eye(numel(e));zeros(1,numel(e))];

end

return

%%

syms a b c real
e = [a;b;c];
h = eu2hm(e)

He = jacobian(h,e)