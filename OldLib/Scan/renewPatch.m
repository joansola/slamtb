function Lmk = renewPatch(Lmk);

% RENEWPATCH  Renew patch
%   LMK = RENEWPATCH(LMK) updates the reference patch of
%   landmark LMK with the current one (which is also stored in
%   LMK structure). The decision is taken depending on criteria
%   on the average and standard deviation of the recent scores
%   history, all this information being updated also within this
%   function.

persistent yellowTh orangeTh redTh stdTh

% fixed parameters for this function
yellowTh = 0.95; % very good match
orangeTh = 0.90; % poor match
redTh    = 0.80; % dangerous match
stdTh    = 0.1; % std deviation th. to renew patch


% Update scores history
Lmk.sch(Lmk.scp) = Lmk.sc;
if Lmk.scp >= Lmk.scl
    Lmk.scp = 1;
else
    Lmk.scp = Lmk.scp + 1;
end
n = length(Lmk.sch);
ss = sum(Lmk.sch);
ss2 = sum(Lmk.sch.^2);
Lmk.scavg = ss/n;
Lmk.scstd = ss2/n - (ss/n)^2;

% [Lmk.sch Lmk.scavg Lmk.scstd]


% decide on patch renew
if      Lmk.scavg < orangeTh && ...
        Lmk.scavg > redTh && ...
        Lmk.scstd < stdTh
    
    Lmk.sig = Lmk.cPatch;
end

