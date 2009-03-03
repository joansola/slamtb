

% e = [2 .2 .3]'

% v = e2v(e)
% 
% R = v2R(v)
% vr = R2v(R)
% vj = R2vjoan(R)

vvr = [];
vvj = [];
pitch = .2; yaw = .3;
a = -pi:.1:pi;
for roll = a
    e = [roll pitch yaw]';

    v = e2v(e);

    R = v2R(v);
    vr = R2v(R);
    vj = R2vjoan(R);

    vvr = [vvr vr];
    vvj = [vvj vj];
    
end

i = 3;
plot(a,vvr(i,:),a,vvj(i,:))
legend('rodrigues','joan')