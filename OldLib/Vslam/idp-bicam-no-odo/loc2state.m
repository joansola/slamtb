function state = loc2state(loc)

% LOC2STATE  Map location to map state conversion

global  WDIM FDIM

state = (loc*WDIM-2)+FDIM;
state = state(:)'; % row vector
