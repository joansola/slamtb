function iK = invIntrinsic(k)

% INVINTRINSIC Build inverse intrinsic matrix

[u0, v0, au, av] = split(k);

iK = [...
    [   1/au,      0, -u0/au]
    [      0,   1/av, -v0/av]
    [      0,      0,      1]];

return

%%
syms u0 v0 au av real
k = [u0 v0 au av]';
K = intrinsic(k);
iK = K^-1

