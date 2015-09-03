function [ Lmk ] = initPapLmk( Lmk, Sen, Frm )
%INITPAPLMK Initializes a complete form pap landmark using the data stored
%into Lmk.par and the frames and sensors

% Type error check
if strcmp(Lmk.type,'papPnt') == false
    error('Expected landmark of type papPnt instead of ''%s''.',Lmk.type);
end

% update lmk sizes
[lmkSize, lmkDSize] = lmkSizes(Lmk.type);
Lmk.state.size  = lmkSize(2);
Lmk.state.dsize = lmkDSize(2);

% get camera anchor poses from frames and sensors
[ maincamframe, assocamframe ] = papLmkCamAnchorFrames( Lmk, Sen, Frm );

% update state
Lmk.state.x = measurements2pap(maincamframe, Lmk.par.mainmeas, ...
                               assocamframe, Lmk.par.assomeas, ...
                               Sen.par.k, Sen.par.c);

Lmk.par.initialpar = Lmk.state.x(9);

end

