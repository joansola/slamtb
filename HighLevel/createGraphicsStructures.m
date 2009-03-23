function [MapFig,SenFig] = createGraphicsStructures(...
    Rob, Sen, Lmk, Obs,...
    SimRob, SimSen, SimLmk,...
    MapFigure, SensorFigure)

% CREATEGRAPHICSSTRUCTURES Create graphics handles structures.


% Init map figure
MapFig = createMapFig(Rob,Sen,Lmk,SimRob,SimSen,SimLmk,MapFigure);

% Init sensor's measurement space figures
SenFig = createSenFig(Sen,Obs,SensorFigure);

