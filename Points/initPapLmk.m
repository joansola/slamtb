function [ Lmk, err ] = initPapLmk( Lmk, Sen, Frm, Opt)
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

% test for max distance between keyframes
if ~Opt.init.papPnt.allowDistAnc && ...
   abs(Frm(Lmk.par.mainfrm).id - Frm(Lmk.par.assofrm).id) > Opt.init.papPnt.maxAncDistKf
    err = 'ancTooFarAway';
    return;
end

% test for minimal parallax to initialize
if pap(9) < Opt.init.papPnt.minParTh
    err = 'notEnoughPar';
    return;
end

% If we get here, we're ok to initialize the landmark

Lmk.state.x = pap;

% set fixedAnchors flag if parallax is good enough
if Lmk.state.x(9) >= Opt.init.papPnt.noReanchorTh
    Lmk.fixedAnchors = true;
else
    Lmk.fixedAnchors = false;
end

% update lmk sizes
[lmkSize, lmkDSize] = lmkSizes(Lmk.type);
Lmk.state.size  = lmkSize(2);
Lmk.state.dsize = lmkDSize(2);

% clear flag to inform calling function that we're ok
err = 0;
    
                    

end

