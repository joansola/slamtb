function loc = state2loc(state)

% STATE2LOC  Map state to map location conversion

global PDIM

loc = (state-PDIM+2)/3;

if loc-floor(loc) ~= 0
    warning('Not valid location for input state')
end