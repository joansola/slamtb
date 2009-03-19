% CREATEGRAPHICSTRUCTURES Create graphics handles structures.
%   This is a script.


% Init map figure
MapFig = createMapFig(Rob,Sen,Lmk,SimRob,SimSen,SimLmk,MapFigure);

% Init sensor's measurement space figures
SenFig = createSenFig(Sen,Obs,SensorFigure);

