function [pose, POSE] = qpose2gtsampose(qp, QP)
import gtsam.*

if nargout < 2
    pose = Pose3(Rot3.Quaternion(qp(4),qp(5),qp(6),qp(7)), ...
             Point3(qp(1:3)));
else
    if size(QP,1) == 1 || size(QP,2) == 1
        [ep,EP] = propagateUncertainty(qp,diag(QP),@qpose2epose); % frame and cov. in euler
    else
        [ep,EP] = propagateUncertainty(qp,QP,@qpose2epose); % frame and cov. in euler
    end
    pose = Pose3(Rot3.RzRyRx(ep(4:6)),Point3(ep(1:3)));
    POSE = [EP(4:6,4:6) EP(4:6,1:3); EP(1:3,4:6) EP(1:3,1:3)];
end

end
