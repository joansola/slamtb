function lmkList = selectLmksToObserve(Obs,N)

% SELECTLMKSTOOBSERVE  Select landmarks to observe.
%   SELECTLMKSTOOBSERVE(Obs,N) returns a sorted rew-vector of landmark
%   indices to be observed. In Active Search, this corresponds to those
%   observations with the largest uncertainty measure (Obs.exp.um). The
%   vector length is limited to N elements.
%
%   See also OBSERVEKNOWNLMKS, SORT.

Oexp = [Obs.exp];   % expectations structure array
um   = [Oexp.um];   % uncertainty measures

% sort from highest to lowest uncertainty measures
[sortedUm,sortedIdx] = sort(um,2,'descend');

% landmark indices, sorted
lmkList = [Obs(sortedIdx).lmk];

% limit to N elements
lmkList = lmkList(1:min(end,N));
