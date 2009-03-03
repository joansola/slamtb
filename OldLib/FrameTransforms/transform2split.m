function [R,t] = transform2split(T)
% TRANSFORM2SPLIT convert homog. transform to R and t
%   [R,t] = TRANSFORM2SPLIT(T)

R = T(1:3,1:3);
t = T(13:15)';

