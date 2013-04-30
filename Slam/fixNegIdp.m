function Lmk = fixNegIdp(Lmk)

% FIXNEGIDP  Fix negative inverse/depth parameter.
%   LMK = FIXNEGIDP(Lmk) tests for negative inverse-depth parameters in
%   landmarks and sets them to a positive 0.001 if necessary.
%
%   See also CORRECTLMK.

%   (c) Joan Sola 2013

global Map

switch Lmk.type
    case {'idpPnt','ahmPnt'}
        if Map.x(Lmk.state.r(end)) < 0
            Map.x(Lmk.state.r(end)) = 0.001; % Fix lmk
        end
    case {'idpLin'}
        if any(Map.x(Lmk.state.r([6,9])) < 0)
            Map.x(Lmk.state.r([6,9])) = 0.001; % Fix lmk
        end
    case {'ahmLin'}
        if any(Map.x(Lmk.state.r([7,11])) < 0)
            Map.x(Lmk.state.r([7,11])) = 0.001; % Fix lmk
        end
end
