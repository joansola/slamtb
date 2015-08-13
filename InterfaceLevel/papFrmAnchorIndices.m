function [ indices ] = papFrmAnchorIndices( Lmk, Fac )
%PAPFRMANCHORINDICES returns the indices of the anchors of a pap pnt in the
%Frm vector.
%   [ INDICES ] = PAPFRMANCHORINDICES( LMK, FAC ) return the indices of the
%   frame anchors in the Frm vector. LMK is a landmark, FAC is a factor
%   vector. If the landmark has only one anchor, INDICES has one value. If
%   the landmark has two anchors, INDICES is a row 2-vector. If the
%   landmark has no anchors, INDICES is empty.

% Error check on lmk type
if strcmp(Lmk.type,'papPnt') == false
    error('Wrong landmark type ''%s''.',Lmk.type);
end
indices = [];

for fac = Lmk.factors
    if numel(Fac(fac).frames) >= 2
        indices = Fac(fac).frames(1:2);
        break;
    elseif numel(Fac(fac).frames) == 1
        indices = Fac(fac).frames(1);
    end
end

end

