function Facs = updateGtsamFactorIndices(Lmks, Facs, updateResult)

import gtsam.*

newFactorsIndices = updateResult.getNewFactorsIndices();

newfac = [Facs.used] & [Facs.new];
replacefac = [Facs.used] & [Facs.replace];
neworreplacefac = newfac | replacefac;

for fac = [Facs(neworreplacefac).fac]
    % Tested needed because some landmarks are not being updated, and thus
    % Facs(fac)gtsamIndex is empty.
    if ~strcmp(Facs(fac).type, 'measurement') || (strcmp(Facs(fac).type, 'measurement') && Lmks(Facs(fac).lmk).optim)
        Facs(fac).gtsamIndex = newFactorsIndices.at(Facs(fac).gtsamIndex);

        % reset 'new' flag if set.
        if Facs(fac).new == true;
            Facs(fac).new = false;
        end

        % reset 'replace' flag if set.
        if Facs(fac).replace == true;
            Facs(fac).replace = false;
        end
    end
end

end
