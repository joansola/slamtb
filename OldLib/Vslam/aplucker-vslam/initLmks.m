% INITLMKS  Initialize landmarks structure

Lmk.maxLine   = maxLine;

% Generate empty structure
Lmk.Line(maxLine) = struct(...
    'id',[],...       % identifier
    'used',[],...     % set if used
    'r',[],...        % range of indices in the map
    's',[-10;10],...  % endpoints abscissas
    'seg',[],...      % segment endpoints
    'shrink',[],...   % flag for endpoints extension control  
    'sens0id',[],...  % original sensor id
    'Sens0',[],...    % Original sensor pose
    'sig',[],...      % signature
    'hist',[],...     % historic
    'HIST',[],...     % historic variances
    'lost',[],...     % lost counter
    'search',[],...   % search counter
    'del',[]);        % flag for deletion form the map

% Fill the only strictly necessary field
[Lmk.Line.used] = deal(false); % all lines are unused
