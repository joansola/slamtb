function [l2, L2_c, L2_l3] = projPlkLinIntoPinHole(c, k, l3)

[l3c , L3C_c , L3C_l3] = toFramePlucker(c, l3);
[l2  , L2_l3c] = pinHolePlucker(k, l3c);

L2_l3 = L2_l3c * L3C_l3;
L2_c = L2_l3c * L3C_c;