function [W,F] = alignWorld(World)

global Map Lmk VDIM

% get the mapped landmarks in order
used = [Lmk.Pnt.used];
used = find(used~=0);

ids = [Lmk.Pnt(used).id];
locs = [Lmk.Pnt(used).loc];

% The mapped world
x = reshape(Map.X(VDIM+1:end),3,[]);

N = size(World,2);
X = zeros(3,N);
X(:,ids) = x(:,locs); % Estimated landmarks

p = diag(Map.P);
p = reshape(p(VDIM+1:end),3,[]);

P = zeros(3,N);
P(:,ids) = p(:,locs); % estimated covariances


% World alignments
nzid = find(sum(X)~=0);
if numel(nzid)>=10
    Xnz = X(:,nzid);
    Wnz = World(:,nzid);
    [t,e] = alignTransform(Wnz,Xnz);
    T = repmat(t,1,size(World,2));
    R = e2R(e);
    W = (R*World + T);
    F.X = [t;e2q(e)];
else
    W = World;
    F.X = [0;0;0;1;0;0;0];
end



% 3D transformation to align world with estimated world
function [t,e] = alignTransform(World,X)
% t is the translation vector
% e is the Euler angles

x0  = [0;0;0;0;0;0];
LB  = [-inf;-inf;-inf;-pi;-pi/2;-pi];
UB  = [inf;inf;inf;pi;pi/2;pi];
opt = optimset('display','none');

x = lsqnonlin(@(x) errfun(x,World,X),x0,LB,UB,opt);

t = x(1:3);
e = x(4:6);



% error function
function err = errfun(x,World,X)

N   = size(World,2);
t   = x(1:3);
T   = repmat(t,1,N);
e   = x(4:6);
R   = e2R(e);
err = X - (R*World + T);
err = err(:);
