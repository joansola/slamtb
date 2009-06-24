function [Lmk,Obs] = smartDeleteLmk(Lmk,Obs)

% SMARTDELETELMK  Smart deletion of landmarks.
%   [Lmk,Obs] = SMARTDELETELMK(Lmk,Obs) detetes landmark Lmk if:
%       * the ratio between inliers and searches is smaller than 0.5, and 
%       * the number of searches is at least 10. 
%   Structure Obs, which must refer to the same landmark, is updated
%   accordingly.
%
%   See also DELETELMK.

if Lmk.nSearch >= 10
    
    ratio = Lmk.nInlier/Lmk.nSearch;
    
    if ratio < 0.5
    
        fprintf('Deleted inconsistent landmark ''%d''.\n',Lmk.id)
        [Lmk,Obs] = deleteLmk(Lmk,Obs);
    end
end
