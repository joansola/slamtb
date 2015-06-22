function printGraph(Rob,Sen,Lmk,Trj,Frm,Fac)

global Map

fprintf('--------------------------\n')
fprintf('Map size: %3d\n', sum(Map.used))
for rob = [Rob.rob]
    printRob(Rob(rob),1);
    for sen = Rob(rob).sensors
        printSen(Sen(sen),2);
    end
    printTrj(Trj(rob),2);
    for i = Trj(rob).head:-1:Trj(rob).head-Trj(rob).length+1
        frm = mod(i-1, Trj(rob).maxLength)+1;
        printFrm(Frm(frm),3);
        for fac = [Frm(frm).factors]
            printFac(Fac(fac),4);
        end
        
    end
    
end
for lmk = find([Lmk.used])
    printLmk(Lmk(lmk),1);
end
end


function tbs = tabs(k, tb)

if nargin == 1
    tb = '  ';
end

tbs = '';
for i = 1:k
    tbs = [tbs tb] ;
end
end


function printRob(Rob,ntabs)
fprintf('%sRob: %2d\n', tabs(ntabs), Rob.rob)
end
function printSen(Sen,ntabs)
fprintf('%sSen: %2d\n', tabs(ntabs), Sen.sen)
end
function printLmk(Lmk,ntabs)
fprintf('%sLmk: %2d (%2d)\n', tabs(ntabs), Lmk.lmk, Lmk.id)
end
function printTrj(Trj,ntabs)
fprintf('%sTrj: head <- %s <-tail\n', tabs(ntabs), num2str(mod((Trj.head:-1:Trj.head-Trj.length+1)-1,Trj.maxLength)+1))
end
function printFrm(Frm,ntabs)
fprintf('%sFrm: %2d (%3d)\n', tabs(ntabs), Frm.frm, Frm.id)
end
function printFac(Fac,ntabs)
fprintf('%sFac: %3d, %s', tabs(ntabs), Fac.fac, Fac.type(1:4))
if (isempty(Fac.lmk)) % abs or motion
    fprintf(', frm: ')
    fprintf('%3d', Fac.frames)
else % measurement
    fprintf(', lmk: %2d', Fac.lmk)
end
fprintf('\n')
end
