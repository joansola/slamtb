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
KM = Lmk.par.mainSen.par.k;
CorrM = Lmk.par.mainSen.par.c;
% asso
CamA = composeFrames(Lmk.par.assoRob.frame,Lmk.par.assoSen.frame);
MeasA = Lmk.par.assoObs.meas.y;
KA = Lmk.par.assoSen.par.k;
CorrA = Lmk.par.assoSen.par.c;

% update state
Lmk.state.x = initPapPnt(CamM,MeasM,CamA,MeasA,KM,CorrM,KA,CorrA);
Lmk.state.dx(1:3,1) = Lmk.state.x(7:9);
                            

end

