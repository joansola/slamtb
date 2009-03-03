function region = countPnts(region,Pnts)

% COUNTPNTS  Count points in each region
%   R = COUNTPNTS(R,PNTS) counts how many points are inside
%   each region in structure array R and returns it in the
%   appropiate fiels of R
%      R.numPnt
%
%   See also COUNTRAYS

% (c) 2005 Joan Sola


u = [Pnts.u];
s = size(region.numPnt);

for i=1:s(1)
    for j=1:s(2)
        u0 = region(i,j).u0;
        du = region(i,j).size;
        u1ok = (u(1,:) > u0(1)) & (u(1,:) < u0(1)+du(1));
        u2ok = (u(2,:) > u0(2)) & (u(2,:) < u0(2)+du(2));
        uok = u1ok & u2ok;
        region(i,j).numPnt = sum(uok);
    end
end
