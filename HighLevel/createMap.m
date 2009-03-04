function Map = createMap(Rob,Sen,Lmk)

R = [Rob.state];
S = [Sen.state];
L = [Lmk.state];

n = sum([R.size S.size L.size]);

Map.used = zeros(n,1);

Map.x = zeros(n,1);
Map.P = zeros(n,n);

Map.size = n;

