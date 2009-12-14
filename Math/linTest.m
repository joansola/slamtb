%% CNTRL + ENTER to execute

% spherical size
s = 1/10;

% Gaussian
x = [4;0;0] + randn(3,1), % avoid singularity of fun() at x1 = 0. 
S = s*randn(3); P=S*S'

% Linearity matrix
Q = linMat(@fun,x,P)
L = linIdx(Q)
