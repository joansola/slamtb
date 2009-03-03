function gh = ground(lim,z,d,ax)

% GROUND draws a ground plane grid
%   GH = GROUND(LIM,Z,D,AX) draws a grid at axies AX with limits
%   LIM=[xmin,xmax,ymin,ymax) at abcissa Z. The grid spacing is D. If AX is
%   not specified it takes AX=gca.

if nargin < 4
    ax = gca;
end

[xm,xM,ym,yM] = deal(lim(1),lim(2),lim(3),lim(4));

% Ground
[x,y] = meshgrid(xm:d:xM,ym:d:yM);
z = z*ones(size(x));
gh = surface(...
    'parent',ax,...
    'XData',x,...
    'YData',y,...
    'ZData',z,...
    'FaceColor','none',...
    'EdgeColor',[.6 .8 .8],...
    'Marker','none');
