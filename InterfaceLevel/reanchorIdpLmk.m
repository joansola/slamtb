function [Lmk,Frms,Facs] = reanchorIdpLmk(Sen,Lmk,Frms,Facs)

% Get a list of anchor frame candidates

% The vector Fac.factors for the factors linking to a idpPnt will be empty
% if the factor is a prior on the lmk inverse depth; will have 1 element if
% it is the main factor; and will have 2 elemens if it's a normal
% projection factor. Since we want to find another frame to reanchor, we
% are interested in the second member of Fac.frames
newanchorfrm = [];
newanchorfac = [];
% TODO: Improve the new anchor selection
for fac = Lmk.factors
    if fac ~= Lmk.par.anchorfac && fac ~= Lmk.par.priorfac
        newanchorfac = fac;
        newanchorfrm = Facs(fac).frames(2);
        break;
    end
end

% If we didn't find a new anchor frame we delete the inverse depth prior
% factor and return here.
if isempty(newanchorfrm)
    if ~isempty(Lmk.par.priorfac)
        Lmk.factors([Lmk.factors] == Lmk.par.priorfac) = [];
        Facs(Lmk.par.priorfac).used = false;
        Facs(Lmk.par.priorfac).frames = [];
        Facs(Lmk.par.priorfac).lmk = [];
        Lmk.par.priorfac = [];
    end
    return;
end

% Update Fac.frames and Frm.factors to match the new anchor
for fac = Lmk.factors
    if fac == Lmk.par.anchorfac
        Facs(fac).frames = [newanchorfrm Lmk.par.anchorfrm]; % Order matters in Facs(fac).frames!
        Frms(newanchorfrm).factors = [Frms(newanchorfrm).factors Lmk.par.anchorfac];
    elseif fac == newanchorfac
        Facs(fac).frames = newanchorfrm; % Order matters in Facs(fac).frames!
        Frms(Lmk.par.anchorfrm).factors([Frms(Lmk.par.anchorfrm).factors] == newanchorfac) = [];
    elseif fac ~= Lmk.par.priorfac
        Facs(fac).frames(1) = newanchorfrm; % Order matters in Facs(fac).frames!
        Frms(Lmk.par.anchorfrm).factors([Frms(Lmk.par.anchorfrm).factors] == fac) = [];
        Frms(newanchorfrm).factors = [Frms(newanchorfrm).factors fac];
    end
end

% Adapt the landmark values to match the new anchor
newanchorcamframe = composeFrames(updateFrame(Frms(newanchorfrm).state),Sen(Lmk.par.anchorsen).frame);
euc = idp2euc(Lmk.state.x);
Lmk.state.x(1:3) = newanchorcamframe.t;
Lmk.state.x(4:5) = vec2py(euc - newanchorcamframe.t);
Lmk.state.x(6)   = 1.0/norm(euc - newanchorcamframe.t);

% Update Lmk.par.anchorxxx pointers
Lmk.par.anchorfrm = newanchorfrm;
Lmk.par.anchorfac = newanchorfac;



