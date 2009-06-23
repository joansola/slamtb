function Sen = map2sen(Sen)
% MAP2SEN  Update Sen structure from the Map information.
%   SEN = MAP2SEN(SEN) updates the structure SEN to reflect the information
%   contained in the golbal map Map.
%
%   See also UPDATEFRAME.

global Map

if Sen.frameInMap

    % normalize quaternion in Map
    Map.x(Rob.frame.r(4:7)) = normvec(Map.x(Rob.frame.r(4:7)));
    
    Sen.state.x = Map.x(Sen.state.r);
    Sen.frame.x = Map.x(Sen.frame.r);

    Sen.frame   = updateFrame(Sen.frame);

end
