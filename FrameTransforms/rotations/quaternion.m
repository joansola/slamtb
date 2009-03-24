% QUATERNION  Help on quaternions for the rotations/ toolbox.
%   
%   We specify a quaternion with a unit, column 4-vector
%
%       q = [a b c d]' , norm(q) = 1.
%
%   with [a] the real part and [b c d]' the imaginary parts. This is
%   equivalent to writing the true quaternion in quaternion space
%
%       q = a + bi + cj + dk, 
%
%   with
%
%       i^2 = j^2 = k^2 = -1, ij = k, ji = -k.
%
%   NOTE: The products performed in quaternion space are indicated with
%   a dot as in (q1.q2). Matrix products are with a star (A*v). 
%
%   Quaternions are used for encoding rotations and orientations with the
%   following convention:
%
%       1. Consider a world or global frame W and a local frame F.
%
%       2. q is used to encode the orientation of frame F wrt frame W. It
%           may be written as q_WF.
%
%       3. Consider now a vector v = vx.i + vy.j + vz.k in quaternion
%       space.
%
%       4. We name v_F and v_W the coordinates of v in frames W and F.
%
%       5. Then, if q_FW = (q_WF)' = a - bi - cj - dk is the conjugate of
%           q_WF, we have
%              v_W = q_WF.v_F.q_FW
%              v_F = q_FW.v_W.q_WF
%
%       6. This is equivalent to the linear, rotation matrix forms 
%              V_W = R_WF*V_F
%              V_F = R_FW*V_W , 
%           with 
%              V_W, V_F : the vectors in Euclidean 3d-space
%              R_WF = q2R(q_WF) 
%              R_FW = R_WF'.
%
%   Some interesting functions involving quaternions are:
%
%       q2qc    conjugate quaternion,      q' = q2qc(q).
%       qProd   product of quaternions, q1.q2 = qProd(q1,q2)
%       q2Q     quaternion matrix,      q1.q2 = q2Q(q1)*q2
%       q2R     rotation matrix. We name R(q) = q2R(q), with the properties:
%           R(q1.q2) = R(q1)*R(q2)
%           R(q')    = R(q)'
%           R(-q)    = R(q)
%       q2e     quaternion to Euler angles conversion
%       q2v     quaternion to rotation vector conversion
%       R2q, e2q, v2q  inverses of q2R, q2e and q2v.
%       qpredict constant angular velocity prediction model.
%
%   Most of these functions are equipped with Jacobian computation for
%   their use in algorithms requiring linearization, such as EKF.
%
%   See also Q2QC, QPROD, Q2Q, Q2R, Q2E, Q2V, R2Q, E2Q, V2Q, QPREDICT,
%   EULERANGLES, EPOSE2QPOSE, QPOSE2EPOSE, FRAME.

%   (c) 2009 Joan Sola @ LAAS-CNRS.
