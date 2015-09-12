function [newpap] = pap2newanchors(pap,newmain,newasso)

vecFromNewMain = papDirectionVecFromOther(pap(7:9),pap(1:3),pap(4:6),newmain);
vecFromNewAsso = papDirectionVecFromOther(pap(7:9),pap(1:3),pap(4:6),newasso);

newpy = vec2py(vecFromNewMain);
newpar = vecsAngle(vecFromNewMain,vecFromNewAsso);

newpap = [newmain; newasso; newpy; newpar];


