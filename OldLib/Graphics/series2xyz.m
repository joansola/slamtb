function [x,y,z] = series2xyz(varargin)
% SERIES2XYZ convert series to X, Y and Z matrices for plotting
%   series are Si = [x y z ...; x y z ...; ...]
%   matrices are
%
%     X = [S1(:,1) S2(:,1), ...]
%     Y = [S1(:,2) S2(:,2), ...]
%     Z = [ ... 3  ...  3   ...]
%
% a 3D plot can be finally produced by simply doing
%
%     plot3(X,Y,Z)
%
% This produces a differently colored line for each series.

n = nargin;       % number of series
v = varargin;     % all the series are cells v{i}, i=1:n
s = size(v{1},1); % length of series

x = zeros(s,n);
y = zeros(s,n);
z = zeros(s,n);
for i=1:n
    x(:,i) = v{i}(:,1);
    y(:,i) = v{i}(:,2);
    z(:,i) = v{i}(:,3);
end
