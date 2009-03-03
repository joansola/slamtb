while true
    brk = false;
    corrTest
    if max(zn)~=zn(21)
        disp('zncc failed.')
        brk=true;
    end
    if min(sd)~=sd(21)
        disp('ssd failed.')
        brk=true;
    end
    if max(cn)~=cn(21)
        disp('census failed.')
%         break
    else
        disp('census ok')
    end
    if brk break
    end
end
