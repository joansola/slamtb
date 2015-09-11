function [Lmks, Frms] = updateStatesFromGtsam(Sen,Lmks,Frms,result)

import gtsam.*

% get new frame values
frms = [Frms.used];

for frm = [Frms(frms).frm]
    Frms(frm).state.x = gtsampose2qpose( result.at( symbol('x',Frms(frm).id) ) );
end

% get new lmk values
lmks = [Lmks.used] & [Lmks.optim];

for lmk = [Lmks(lmks).lmk]
    mainanchorid = Frms(Lmks(lmk).par.mainfrm).id;
    assoanchorid = Frms(Lmks(lmk).par.assofrm).id;
    
    mainFrame.x = gtsampose2qpose(result.at( symbol('x',mainanchorid) ));
    assoFrame.x = gtsampose2qpose(result.at( symbol('x',assoanchorid) ));
    
    mainCamFrame = composeFrames(updateFrame(mainFrame),Sen.frame);
    assoCamFrame = composeFrames(updateFrame(assoFrame),Sen.frame);
    
    Lmks(lmk).state.x(1:3) = mainCamFrame.t;
    Lmks(lmk).state.x(4:6) = assoCamFrame.t;
    Lmks(lmk).state.x(7:9) = result.at( symbol('l',Lmks(lmk).id) ).vector;
    
end
