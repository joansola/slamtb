function [ Lmks, Frms, initialEstimates] = getGtsamValues(Lmks, Frms, initialEstimates)

import gtsam.*

% get frame values
frms = [Frms.used];

for Frm = Frms(frms)
    initialEstimates.insert(symbol('x',Frm.id), qpose2gtsampose( Frm.state.x ));
end

% get lmk values
lmks = [Lmks.used] & [Lmks.optim];

for Lmk = Lmks(lmks)
    initialEstimates.insert(symbol('l',Lmk.id), ParallaxAnglePoint3( Lmk.state.x(7:9) ));
end

