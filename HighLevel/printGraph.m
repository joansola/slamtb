function printGraph(Rob,Sen,Lmk,Trj,Frm,Fac)

global Map

fprintf('--------------------------\n')
for rob = [Rob.rob]
    ntabs = 1;
    printRob(Rob(rob),ntabs);
    for sen = Rob(rob).sensors
        ntabs = 2;
        printSen(Sen(sen),ntabs);
    end
    ntabs = 2;
    printTrj(Trj(rob),ntabs);
    for i = Trj(rob).head:-1:Trj(rob).head-Trj(rob).length+1
        frm = mod(i-1, Trj(rob).maxLength)+1;
        ntabs = 3;
        printFrm(Frm(frm),ntabs);
        for fac = [Frm(frm).factors]
            ntabs = 4;
            printFac(Fac(fac),ntabs);
        end
        
    end
    
end
for lmk = find([Lmk.used])
    ntabs = 1;
    printLmk(Lmk(lmk),ntabs);
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
fprintf('%sRob: %d\n', tabs(ntabs), Rob.rob)
end
function printSen(Sen,ntabs)
fprintf('%sSen: %d\n', tabs(ntabs), Sen.sen)
end
function printLmk(Lmk,ntabs)
fprintf('%sLmk: %d\n', tabs(ntabs), Lmk.lmk)
end
function printTrj(Trj,ntabs)
fprintf('%sTrj: %d\n', tabs(ntabs), Trj.rob)
end
function printFrm(Frm,ntabs)
fprintf('%sFrm: %d\n', tabs(ntabs), Frm.frm)
end
function printFac(Fac,ntabs)
fprintf('%sFac: %d\n', tabs(ntabs), Fac.fac)
fprintf('%sframes: %s\n', tabs(ntabs+1), num2str(Fac.frames))
if (~isempty(Fac.lmk))
    fprintf('%slmk   : %s\n', tabs(ntabs+1), num2str(Fac.lmk))
end
end
