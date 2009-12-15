%% CNTRL + ENTER to execute (if you have cell mode activated)

% spherical size
s = rand;

% Gaussian
x = randn(2,1); % avoid singularity of fun() at x1 = 0. 
S = s*randn(2); P=S*S';

% Linearity matrix
Q = linMat(@f21,x,P);
L = linIdx(Q)

% plots
%=======
% create a mesh for the NL function
ii = -3:.4:3;
jj = ii;
N = length(ii);
Z=zeros(N);
for i = 1:N
    for j = 1:N
        Z(j,i) = f21([ii(i);jj(j)]);
    end
end
cla
% Plot the NL function as a mesh
m = mesh(ii,jj,Z,'facealpha',0,'edgecolor','g','edgealpha',.5);
% adjust fig and axes properties
cameratoolbar('setmode','orbit')
axis equal
set(gcf,'renderer','opengl')
set(gca,'projection','perspective')
view(30,40)
% plot the ellipse projected on the surface
e = line;
[ex,ey] = cov2elli(x,P,2,40); % the 2-d ellipse...
for i = 1:length(ex)
    ez(i) = f21([ex(i);ey(i)]); % ...projected to the surface of f21()
end
set(e,'xdata',ex,'ydata',ey,'zdata',ez+.05,'linewidth',2)
