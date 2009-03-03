function [x,Xh] = hmProject(hm)

x = hm(1:2,:)./hm(3,:);

if nargout > 1 && size(hm,2) == 1
    
    

    Xh = [...
        [ 1/hm(3),       0, -hm(1)/hm(3)^2,      0]
        [       0, 1/hm(3), -hm(2)/hm(3)^2,      0]];

end

return

%% jacobians

syms x y z t real

hm = [x;y;z;t];

x = hmProject(hm);

Xh = simple(jacobian(x,hm))


