function state = loc2state(loc)

% LOC2STATE  Map location to map state conversion

global  WDIM VDIM

state = (loc*WDIM-2)+VDIM;
state = state(:)'; % row vector
