function region = countRays(region,Rays)

% COUNTRAYS  Count rays in each region
%   R = COUNTRAYS(R,RAYS) counts how many ray means are inside
%   each region in structure array R and returns it in the
%   appropiate fiels of R
%      R.numRay
%
%   See also COUNTPNTS

% (c) 2005 Joan Sola


u = [Rays.u0]; % all mean points in rays
s = size(region);

for i=1:s(1)
    for j=1:s(2)
        u0 = region(i,j).u0;
        du = region(i,j).size;
        u1ok = (u(1,:) > u0(1)) & (u(1,:) < u0(1)+du(1));
        u2ok = (u(2,:) > u0(2)) & (u(2,:) < u0(2)+du(2));
        uok = u1ok & u2ok;
        region(i,j).numRay = sum(uok);
    end
end
