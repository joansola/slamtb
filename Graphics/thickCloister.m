function world = thickCloister(x,X,y,Y,h,n)

switch nargin
    case {1, 2, 3, 4}
        n = 9;
        h = 1;
    case 5
        n = 9;
end

plane = cloister(x,X,y,Y,n);
nlm = length(plane);
low = zeros(1,nlm);
high  = low + h;
world = [plane plane;low high];

% nid = 2*nlm;

% ids = 1:nid;

% id = 0;
% ids = zeros(1,nid);
% for i = 1:nid
%     id = id+floor(10*rand+1);
%     ids(i) = id;
% end

% world = [ids;world];
