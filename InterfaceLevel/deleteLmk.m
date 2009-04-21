function [Lmk,Obs] = deleteLmk(Lmk,Obs)

% DELETELMK  Delete landmark.
% 	[Lmk,Obs] = DELETELMK(Lmk,Obs) deletes the landmark Lmk from the map
% 	Map and clears the necessary flags in Lmk and Obs.

global Map

Map.used(Lmk.state.r) = false;
Lmk.used    = false;
Obs.vis     = false;
