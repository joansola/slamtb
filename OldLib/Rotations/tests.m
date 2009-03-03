%%

syms p q r real % attitude
syms x y z real % position
syms w1 w2 w3 real % rotation speed

t = [x y z]';
v = [p q r]';
X = [t;v];

w = [w1 w2 w3]';

%%
Rw1 = v2R(v);
R12 = v2R(w);
Rw2 = Rw1*R12;
v2 = R2v(Rw2);

%%
% v = [-.1 -.2 -.3]'
% R = v2R(v)
% v = R2v(R)

%% Jacobians
V2v = jacobian(v2,v)
V2w = jacobian(v2,w)