function [ lmkSize, lmkDSize ] = lmkSizes( lmkType )
%LMKSIZES( LMKTYPE ) returns the sizes used by a especific landmark type
%
%  [ LMKSIZE, LMKDSIZE ] = LMKSIZES( LMKTYPE ) returns the landmark sizes
%  in LMKSIZE and the landmark error state sizes in the LMKDSIZE. Both
%  LMKSIZE and LMKDSIZE are 1x2 vectors, with the first element being the
%  initial value and the second being the nominal value. In most of the
%  cases both elements of each vector will be the same. They won't be the
%  same if:
%    1) The landmark has a specific initial (normally incomplete)
%    parametrization: then LMKTYPE(1) ~= LMKTYPE(2);    
%    2) The landmark has a specific initial error state (normally zero):
%    then LMKDTYPE(1) ~= LMKDTYPE(2);

%   Copyright 2015   Ellon Paiva @ LAAS-CNRS

% TODO: Define lmkDSize for all lmk types

global Map

switch lmkType
    case {'hmgPnt'}
        lmkSize = [4 4]; %lmkDSize = [? ?];
    case {'ahmPnt'}
        lmkSize = [7 7]; %lmkDSize = [? ?];
    case {'idpPnt'}
        switch Map.type
            case 'graph'
                % we don't keep the anchor part of the lmk
                lmkSize = [6 6]; lmkDSize = [3 3];
            otherwise
                lmkSize = [6 6]; lmkDSize = [6 6];
        end
    case {'papPnt'}
        switch Map.type
            case 'graph'
                % we don't keep the anchor part of the lmk
                lmkSize = [5 9]; lmkDSize = [0 3];
            otherwise
                lmkSize = [9 9]; lmkDSize = [9 9];
        end
        
    case {'plkLin'}
        lmkSize = [6 6]; %lmkDSize = ?; lmkInitDSize = ?;
    case {'idpLin','aplLin'}
        lmkSize = [9 9]; %lmkDSize = [? ?];
    case {'hmgLin'}
        lmkSize = [8 8]; %lmkDSize = [? ?];
    case {'ahmLin'}
        lmkSize = [11 11]; %lmkDSize = [? ?];
    case {'eucPnt'}
        switch Sen.type
            case 'pinHoleDepth'
                lmkSize = [3 3]; lmkDSize = [3 3];
            otherwise
                error('??? Unable to initialize lmk type ''%s''. Try using ''idpPnt'' instead.',lmkType);
        end
    otherwise
        error('??? Unknown landmark type ''%s''.', lmkType);
end

end

