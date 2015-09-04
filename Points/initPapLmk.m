function [ Lmk, failed ] = initPapLmk( Lmk, Sen, Frm, Opt)
%INITPAPLMK Initializes a complete form pap landmark using the data stored
%into Lmk.par and the frames and sensors

% Type error check
if strcmp(Lmk.type,'papPnt') == false
    error('Expected landmark of type papPnt instead of ''%s''.',Lmk.type);
end

% get camera anchor poses from frames and sensors
[ maincamframe, assocamframe ] = papLmkCamAnchorFrames( Lmk, Sen, Frm );

% get initial estimate
pap = measurements2pap(maincamframe, Lmk.par.mainmeas, ...
                       assocamframe, Lmk.par.assomeas, ...
                       Sen.par.k, Sen.par.c);

% test for minimal parallax to initialize
if pap(9) >= Opt.init.papPnt.minParTh
    Lmk.state.x = pap;
    Lmk.par.initialpar = pap(9);

    % update lmk sizes
    [lmkSize, lmkDSize] = lmkSizes(Lmk.type);
    Lmk.state.size  = lmkSize(2);
    Lmk.state.dsize = lmkDSize(2);

    failed = false;
else
    failed = true;
end
                    

end

