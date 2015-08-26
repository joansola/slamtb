function [Fac,Frm,Lmk] = deleteFactor(Fac,Frm,Lmk)

% [FAC,FRM,LMK] = DELETEFACTOR(FAC,FRM,LMK) cleans up the graph and delete
% the factor (set its flags so the element in the factor vector it will be
% considered free).

global Map

for frm = [Fac.frames];
    % Remove this factor from frame's factors list
    Frm(frm).factors([Frm(frm).factors] == Fac.fac) = [];
end

for lmk = [Fac.lmk]
    % Remove this factor from landmark's factors list
    Lmk(lmk).factors([Lmk(lmk).factors] == Fac.fac) = [];

    % Delete landmark if no factors support it
    if isempty(Lmk(lmk).factors)
%                 fprintf('Deleting Lmk ''%d''.\n', lmk)
        Lmk(lmk).used = false;
        Lmk(lmk) = clearLmkParams(Lmk(lmk));
        Map.used(Lmk(lmk).state.r) = false;
    end
end

% Free (and cleanup just in case) factors from tail before advancing
%         fprintf('Deleting Fac ''%d''.\n', fac)
Fac.used = false;
Fac.remove = true; % Flag to be cleared by GTSAM functions
Fac.frames = [];
Fac.lmk = [];
