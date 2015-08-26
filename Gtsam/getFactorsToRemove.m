function factorsToRemove = getFactorsToRemove(Facs,factorsToRemove)

import gtsam.*

removefac = [Facs.used] & [Facs.remove];

for fac = [Facs(removefac).fac]
    factorsToRemove.push_back(Facs(fac).gtsamIndex);
    Facs(fac).gtsamIndex = [];
    Facs(fac).remove = false;
end

% NOTE: We do not clear the flags here yet. See UPDATEGTSAMFACTORINDEXES.