% COPLANAR script to evaluate coplanarity
% select points from figure and enter them in p_xx
% then build array p as follows:
% p = [p_01;p_02;p_03;...;p_nn;]';

p = [p_01;p_02;p_03;p_04;p_05;p_06;p_07;p_08;p_09;p_10;p_11;p_12;p_13;]';

pp=[];
for i=1:13
    pp=[pp;p(i).Position];
end

ipp = pinv(pp);
pp1=ones(13,1);
P=ipp*pp1;
D=1/norm(P); % independent coefficient
P=P*D; % normal vector to plane

d=pp*P-D; % distances to opptimal plane

d_mean = mean(d) % mean - should be zero
d_std  = std(d)  % sigma - this is the co-planarity error

