function [Rob,Sen,Lmk,Obs] = correctLmk(Rob,Sen,Lmk,Obs)

global Map

% Pxrsl = Map.P(Map.used,rslr)
% Hrsl  = [jacobianas jac jac]
% 
% x == Map.x(Map.used)
% P == Map.P(Map.used,Map.used)
% 
% K = Pxrsl*Hrsl'*iZ
% x = x + K*z
% P = P - K*Z*K'
% 
% Rob = map2rob(Rob)
% Sen = map2sen(Sen)


% TODO: all the function


