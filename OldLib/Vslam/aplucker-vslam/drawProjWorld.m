function 	dispProjWorld = drawProjWorld(dispProjWorld,obsSegments)

% DRAWPROJWORLD  Draw projected world.

X = obsSegments([1 3],:);
Y = obsSegments([2 4],:);

names = {'xdata','ydata'};

m = size(X,2);
M = ones(1,m);
N = [2 2];
values = mat2cell([X',Y'],M,N);

set(dispProjWorld(1:m),names,values);
set(dispProjWorld(m+1:end),names,{[],[]});