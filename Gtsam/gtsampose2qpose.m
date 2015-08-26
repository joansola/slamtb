function [qp] = gtsampose2qpose(gtsamp)
import gtsam.*

qp(1:3,1) = gtsamp.translation.vector;
qp(4:7,1) = gtsamp.rotation.quaternion;

end