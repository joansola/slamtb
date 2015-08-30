function Lmks = reinitLmkValuesOnGtsam(Lmks)

import gtsam.*

global Map

reinitValues = gtsam.Values;

% Gather landmark values to be reinitialized
resetlmks = [Lmks.used] & [Lmks.optim] & [Lmks.reset];
for Lmk = Lmks(resetlmks)
    reinitValues.insert(symbol('l',Lmk.id), ParallaxAnglePoint3( Lmk.state.x(7:9) ));
end

if ~reinitValues.empty()
    % Reinit them inside ISAM2
    Map.gtsam.isam.updateLinearizationPoint(reinitValues);

    % Clear reset flag
    [Lmks(resetlmks).reset] = deal(false);
end

