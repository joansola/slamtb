function [ Lmks, Frms, initialEstimates] = getNewGtsamValues(Lmks, Frms, initialEstimates)

import gtsam.*

% get new frame values
newfrms = [Frms.used] & [Frms.new];

for Frm = Frms(newfrms)
    initialEstimates.insert(symbol('x',Frm.id), qpose2gtsampose( Frm.state.x ));
end

[Frms(newfrms).new] = deal(false);

% get new lmk values
newlmks = [Lmks.used] & [Lmks.optim] & [Lmks.new];

for Lmk = Lmks(newlmks)
    initialEstimates.insert(symbol('l',Lmk.id), ParallaxAnglePoint3( Lmk.state.x(7:9) ));
end

[Lmks(newlmks).new] = deal(false);

