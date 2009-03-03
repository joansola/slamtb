% INITLMKS  Initialize landmark structure

Lmk.maxRay     = maxRay;      % Maximum number of rays
Lmk.maxPnt     = maxPnt;      % Maximum number of points
Lmk.simultRay  = simultRay;   % Maximum simultaneous ray updates
Lmk.simultPnt  = simultPnt;   % Maximum simultaneous point updates
Lmk.maxInit    = maxInit;     % Maximum simultaneous initializations

Lmk = fillPnts(Lmk);
Lmk = fillRays(Lmk);

