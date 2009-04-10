function Sen = map2sen(Sen)
% MAP2SEN  Update Sen structure from the Map information.
%   SEN = MAP2SEN(SEN) updates the structure SEN to reflect the information
%   contained in the golbal map Map.
%
%   See also UPDATEFRAME.

global Map

if ~isempty(Sen.state.r)

    % means
    Sen.state.x = Map.x(Sen.state.r);
    Sen.frame.x = Map.x(Sen.frame.r);

    Sen.frame   = updateFrame(Sen.frame);

    % covariances
    %     Sen.state.P = Map.P(Sen.state.r,Sen.state.r);
    %     Sen.frame.P = Map.P(Sen.frame.r,Sen.frame.r);

end
