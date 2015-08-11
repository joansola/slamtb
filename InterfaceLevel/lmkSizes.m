function [ lmkSize, lmkDSize, lmkInitDSize ] = lmkSizes( lmkType )
%LMKSIZES( LMKTYPE ) returns the sizes used by a especific landmark type
%
%  [ LMKSIZE, LMKDSIZE, LMKINITDSIZE ] = LMKSIZES( LMKTYPE ) returns the
%  landmark size LMKSIZE, the landmark error state size LMKDSIZE, and the
%  landmark initial error state size LMKINITDSIZE. In most of the cases the
%  LMKDSIZE and LMKINITDSIZE will be the same unless we do not want to
%  delay the addition of the landmark to the solver.

%   Copyright 2015   Ellon Paiva @ LAAS-CNRS

% TODO: Define lmkDSize and lmkInitDSize for all lmk types

global Map

switch lmkType
    case {'hmgPnt'}
        lmkSize = 4; %lmkDSize = ?; lmkInitDSize = ?;
    case {'ahmPnt'}
        lmkSize = 7; %lmkDSize = ?; lmkInitDSize = ?;
    case {'idpPnt'}
        switch Map.type
            case 'graph'
                % we don't keep the anchor part of the lmk
                lmkSize = 6; lmkDSize = 3; lmkInitDSize = 3;
            otherwise
                lmkSize = 6; lmkDSize = 6; lmkInitDSize = 6;
        end
    case {'plkLin'}
        lmkSize = 6; %lmkDSize = ?; lmkInitDSize = ?;
    case {'idpLin','aplLin'}
        lmkSize = 9; %lmkDSize = ?; lmkInitDSize = ?;
    case {'hmgLin'}
        lmkSize = 8; %lmkDSize = ?; lmkInitDSize = ?;
    case {'ahmLin'}
        lmkSize = 11; %lmkDSize = ?; lmkInitDSize = ?;
    case {'eucPnt'}
        switch Sen.type
            case 'pinHoleDepth'
                lmkSize = 3; lmkDSize = 3; lmkInitDSize = 3;
            otherwise
                error('??? Unable to initialize lmk type ''%s''. Try using ''idpPnt'' instead.',lmkType);
        end
    otherwise
        error('??? Unknown landmark type ''%s''.', lmkType);
end

end

