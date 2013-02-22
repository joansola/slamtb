function [Lmk,Obs] = smartDeleteLmk(Lmk,Obs)

% SMARTDELETELMK  Smart deletion of landmarks.
%   [Lmk,Obs] = SMARTDELETELMK(Lmk,Obs) detetes landmark Lmk if:
%       * the ratio between inliers and searches is smaller than 0.5, and
%       * the number of searches is at least 10.
%   Structure Obs, which must refer to the same landmark, is updated
%   accordingly.
%
%   See also DELETELMK.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

switch Lmk.type
    case {'idpPnt','ahmPnt'}
        if Map.x(Lmk.state.r(end)) < 0
            [Lmk,Obs] = deleteLmk(Lmk,Obs);
        end
    case {'idpLin'}
        if any(Map.x(Lmk.state.r([6,9])) < 0)
            [Lmk,Obs] = deleteLmk(Lmk,Obs);
        end
    case {'ahmLin'}
        if any(Map.x(Lmk.state.r([7,11])) < 0)
            [Lmk,Obs] = deleteLmk(Lmk,Obs);
        end
end

if Lmk.nSearch >= 10

    matchRatio       = Lmk.nMatch  / Lmk.nSearch;
    consistencyRatio = Lmk.nInlier / Lmk.nMatch;

    if matchRatio < 0.1 
        fprintf('Deleted unstable landmark ''%d''.\n',Lmk.id)
        [Lmk,Obs] = deleteLmk(Lmk,Obs);
    end

    if consistencyRatio < 0.5
        fprintf('Deleted inconsistent landmark ''%d''.\n',Lmk.id)
        [Lmk,Obs] = deleteLmk(Lmk,Obs);
    end
    
%     if Obs.exp.um > 10000
%         fprintf('Deleted old landmark ''%d''.\n',Lmk.id)
%         [Lmk,Obs] = deleteLmk(Lmk,Obs);
%     end
    
end









