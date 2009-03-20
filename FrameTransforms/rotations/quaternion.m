% QUATERNION  Help on quaternions for the SLAM toolbox.
%   
%   We define a quaternion as a column, unit 4-vector
%
%       q = [a b c d]' , norm(q) = 1.
%
%   with  a  the real part and [b c d]' the imaginary parts. This is
%   equivalent to writing the true quaternion in quaternion space
%
%       q = a + bi + cj + dk, i^2 = j^2 = k^2 = -1, ij = k, ji = -k.
%
%   NOTE: The products performed in quaternion space are indicated with
%   a dot as in (q1.q2). Matrix products are with a star (A*v). 
%
%   Quaternions are used for encoding rotations and orientations with the
%   following convention:
%
%       * Consider a world frame W and a frame F.
%       * q is used to encode the orientation of frame F wrt frame W.
%       * It may be written as q_WF.
%       * Consider now a vector v = [0 vx vy vz]' in quaternion space. We
%       write v_F and v_W to name their coordinates in frames W and F.
%       * Then we have  v_W = q_WF.v_F.q_FW, with q_FW = (q_WF)', the
%       conjugate of q_WF.
%       * This is equivalent to the rotation matrix form V_W = R_WF*V_F*R_FW
%       with R_WF = q2R(q_WF), R_FW = R_WF' and V_{W,F} in Euclidean space.
%
%   Some interesting functions involving quaternions are:
%
%       q2qc    conjugate quaternion, q' = q2qc(q).
%       qProd   product of quaternions,  q1.q2 = qProd(q1,q2)
%       q2Q     quaternion to quaternion matrix, ie:
%           q1.q2 = q2Q(q1)*q2
%       q2R     rotation matrix. We have R = q2R(q), with the properties:
%           R(q1.q2) = R1*R2
%           R(q') = R(q)'
%           R(-q) = R(q)
%       q2e     quaternion to Euler angles conversion
%       q2v     quaternion to rotation vector conversion
%       R2q, e2q, v2q  inverses of q2R, q2e and q2v.
%       qpredict constant angular velocity prediction model based on
%       quaternon.
%
%   See also Q2QC, QPROD, Q2Q, Q2R, Q2E, Q2V, R2Q, E2Q, V2Q, QPREDICT.
