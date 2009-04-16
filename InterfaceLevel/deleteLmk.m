function [Lmk,Obs] = deleteLmk(Lmk,Obs)

% DELETELMK  Delete landmark.
% TODO: help

r           = Lmk.state.r;
Map.used(r) = false;
Lmk.used    = false;
Obs.vis     = false;
