function [ Lmk ] = initPapLmk( Lmk )
%INITPAPLMK Initializes a complete form pap landmark using the data stored
%into Lmk.par

% Type error check
if strcmp(Lmk.type,'papPnt') == false
    error('Expected landmark of type papPnt instead of ''%s''.',Lmk.type);
end

% update lmk sizes
[lmkSize, lmkDSize] = lmkSizes(Lmk.type);
Lmk.state.size  = lmkSize(2);
Lmk.state.dsize = lmkDSize(2);

% get values from Lmk.par
% main
CamM = composeFrames(Lmk.par.mainRob.frame,Lmk.par.mainSen.frame);
MeasM = Lmk.par.mainObs.meas.y;
kM = Lmk.par.mainSen.par.k;
cM = Lmk.par.mainSen.par.c;
% asso
CamA = composeFrames(Lmk.par.assoRob.frame,Lmk.par.assoSen.frame);
MeasA = Lmk.par.assoObs.meas.y;
kA = Lmk.par.assoSen.par.k;
cA = Lmk.par.assoSen.par.c;

% update state
Lmk.state.x = initPapPnt(CamM,MeasM,CamA,MeasA,kM,cM,kA,cA);

end

