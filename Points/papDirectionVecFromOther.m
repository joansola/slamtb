function [vecFromOther, VECFROMOTHER_minpap, VECFROMOTHER_ma, VECFROMOTHER_aa, VECFROMOTHER_oa] ...
    = papDirectionVecFromOther(minpap,ma,aa,oa)

if nargout == 1

    py  = minpap(1:2,1);
    par = minpap(3,1);

    uvecMtoP = py2vec(py); % unit vector

    aama = aa - ma;

    uvecMtoA = normvec(aama); % unit vector
    
    phi = acos( dot(uvecMtoP,uvecMtoA) );
    
    normaama = vecnorm(aama);
    
    sinparphi = sin(par + phi);
    
    vecFromOther = sinparphi*normaama*uvecMtoP - sin(par)*(oa - ma);
    
else

    py  = minpap(1:2,1);
    par = minpap(3,1);

    [uvecMtoP, UVECMTOP_py] = py2vec(py); % unit vector

    aama = aa - ma;
    AAMA_aa = eye(3);
    AAMA_ma = -eye(3);

    [uvecMtoA, UVECMTOA_aama] = normvec(aama); % unit vector

    phi = acos( dot(uvecMtoP,uvecMtoA) );
    PHI_uvecmtop = -1/(1 - dot(uvecMtoP,uvecMtoA)^2)^(1/2) * uvecMtoA';
    PHI_uvecmtoa = -1/(1 - dot(uvecMtoP,uvecMtoA)^2)^(1/2) * uvecMtoP';

    [normaama, NORMAAMA_aama] = vecnorm(aama);

    sinparphi = sin(par + phi);
    SINPARPHI_par = cos(par + phi);
    SINPARPHI_phi = cos(par + phi);

    vecFromOther = sinparphi*normaama*uvecMtoP - sin(par)*(oa - ma);
    %TODO: Check the jacobians below using info on https://en.wikipedia.org/wiki/Matrix_calculus
    VECFROMOTHER_ma  = kron(( (SINPARPHI_phi*PHI_uvecmtoa*UVECMTOA_aama*AAMA_ma)*normaama + sinparphi*(NORMAAMA_aama*AAMA_ma) ),uvecMtoP) + sin(par)*eye(3);
    VECFROMOTHER_aa  = kron(( (SINPARPHI_phi*PHI_uvecmtoa*UVECMTOA_aama*AAMA_aa)*normaama + sinparphi*(NORMAAMA_aama*AAMA_aa) ),uvecMtoP);
    VECFROMOTHER_py  = normaama*( uvecMtoP*(SINPARPHI_phi*PHI_uvecmtop*UVECMTOP_py) + sinparphi*(UVECMTOP_py) );
    VECFROMOTHER_par = SINPARPHI_par*normaama*uvecMtoP - cos(par)*(oa - ma);
    VECFROMOTHER_minpap = [VECFROMOTHER_py VECFROMOTHER_par];
    VECFROMOTHER_oa  = -sin(par)*eye(3);

end

return

%% 
%%
% Declare symbolic real variables
syms p y par real
syms max may maz real
syms aax aay aaz real
syms oax oay oaz real

% build vectors
pap = [p y par]';                
ma =  [max may maz]';
aa =  [aax aay aaz]';
oa =  [oax oay oaz]';

% Call function to test with symbolic input
[vecFromOther, VECFROMOTHER_pap, VECFROMOTHER_ma, VECFROMOTHER_aa, VECFROMOTHER_oa] = papDirectionVecFromOther(pap,ma,aa,oa);

% Verify that jacobian() returns the same as our Jacobian.
simplify(VECFROMOTHER_pap - jacobian(vecFromOther,pap))
simplify(VECFROMOTHER_ma  - jacobian(vecFromOther,ma))
simplify(VECFROMOTHER_aa  - jacobian(vecFromOther,aa))
simplify(VECFROMOTHER_oa  - jacobian(vecFromOther,oa))

% Verify if we can add jacobian wrt aa and oa when oa == aa
[vecFromOther, VECFROMOTHER_pap, VECFROMOTHER_ma, VECFROMOTHER_aa, VECFROMOTHER_oa] = papDirectionVecFromOther(pap,ma,aa,aa);
VECFROMOTHER_aa = VECFROMOTHER_aa + VECFROMOTHER_oa;

simplify(VECFROMOTHER_pap - jacobian(vecFromOther,pap))
simplify(VECFROMOTHER_ma  - jacobian(vecFromOther,ma))
simplify(VECFROMOTHER_aa  - jacobian(vecFromOther,aa))

