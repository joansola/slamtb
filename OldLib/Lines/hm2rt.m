function [rt,RThm] = hm2rt(hm)

% HM2RT  Homogeneous to rho-theta line expression in the plane.
%   HM2RT(HM) converts the homogeneous line HM to its rho-theta
%   representation.
%
%   [rt,RT_hm] = HM2RT(...) returns the Jacobian wrt HM.

if ~isa(hm,'sym') && hm(3) > 0
    hm2 = -hm;
    s = -1;
else
    hm2 = hm;
    s = 1;
end

[a,b,c] = split(hm2);

r2 = dot([a,b],[a,b]);
r  = sqrt(r2);

ct  =  a/r;
st  =  b/r;
rho = -c/r;

if isa(hm2,'sym')
    theta = atan(st/ct);
else
    theta = atan2(st,ct);
end

rt = [rho;theta];

if nargout > 1

    r3 = r*r2;

    RThm = s * [...
        [ a*c/r3, b*c/r3,  -1/r]
        [  -b/r2,   a/r2,     0]];

end

return

%%

syms a b c real
hm = [a;b;c];

[rt] = hm2rt(hm)

%%
RThm = jacobian(rt,hm)

simplify(RThm - jacobian(rt,hm))

%%
clc
hm = [-1;1;1];
[rt,RThm] = hm2rt(hm)
[rt,RThm] = hm2rt(-hm)

hm = [1;-1;1];
[rt,RThm] = hm2rt(hm)
[rt,RThm] = hm2rt(-hm)


%% incremental jacobian
clc
dx = 1e-10;
l0 = -[1;2;3];
[rt0,RTl0] = hm2rt(l0);
RTl = zeros(2,3);
for i = 1:3
    l = l0;
    l(i) = l(i) + dx;
    rt = hm2rt(l);
    RTl(:,i) = (rt-rt0)/dx;
end
rt0;
RTl
RTl0
