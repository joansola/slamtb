function state = loc2state(loc)

% LOC2STATE  Map location to map state conversion

global  VDIM HDIM

state = VDIM + 1 + HDIM*(loc-1);
state = state(:)'; % row vector
