function [newpap] = pap2newanchors(pap,newmain,newasso)

euc = pap2euc(pap);

vecNewMainToEuc = euc - newmain;
vecNewAssoToEuc = euc - newasso;

newpy = vec2py(vecNewMainToEuc);
newpar = acos( dot(vecNewMainToEuc,vecNewAssoToEuc) / (norm(vecNewMainToEuc)*norm(vecNewAssoToEuc)) );

newpap = [newmain; newasso; newpy; newpar];


