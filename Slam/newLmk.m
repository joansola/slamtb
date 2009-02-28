function Lmk = newLmk(id,type,sig)

% initially assigned things
Lmk.id      = id;    % identifier
Lmk.type    = type;  % type
Lmk.sig     = sig;   % signature

% things statically assigned
Lmk.used    = 0;     % flag if Lmk is used
Lmk.nsearch = 0;     % number of times searched
Lmk.nmatch  = 0;     % number of times matched
Lmk.ninlier = 0;     % number of times validated as inlier

% things to assign later
Lmk.x       = [];    % geometric parameters
Lmk.e       = [];    % other parameters
Lmk.xr      = [];    % geometric range in Map
Lmk.er      = [];    % other params range in Map
Lmk.r       = [];    % range in Map

