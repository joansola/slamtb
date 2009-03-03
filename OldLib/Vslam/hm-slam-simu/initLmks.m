% INITLMKS  Initialize landmark structure

Lmk.maxPnt     = maxPnt;      % Maximum number of points
Lmk.simultPnt  = simultPnt;   % Maximum simultaneous point updates
Lmk.maxInit    = maxInit;     % Maximum simultaneous initializations

Lmk = fillPnts(Lmk);

