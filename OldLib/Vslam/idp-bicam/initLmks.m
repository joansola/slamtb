% INITLMKS  Initialize landmark structure

Lmk.maxIdp     = maxIdp;      % Maximum number of Idp rays
Lmk.maxPnt     = maxPnt;      % Maximum number of points
Lmk.simultIdp  = simultIdp;   % Maximum simultaneous ray updates
Lmk.simultPnt  = simultPnt;   % Maximum simultaneous point updates
Lmk.maxInit    = maxInit;     % Maximum simultaneous initializations

Lmk.Pnt = fillPnts(Lmk.maxPnt);
Lmk.Idp = fillIdps(Lmk.maxIdp);

