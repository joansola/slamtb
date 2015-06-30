function err = checkGraphIntegrity(Lmk,Frm,Fac)

for fac = find([Fac.used])
    for frm = Fac(fac).frames
        if all(Frm(frm).factors ~= fac)
            fprintf('Fac %d has Frm %d but not viceversa\n', fac, frm)
        end
    end
    for lmk = Fac(fac).lmk
        if all(Lmk(lmk).factors ~= fac)
            fprintf('Fac %d has Lmk %d but not viceversa\n', fac, lmk)
        end
    end
    
end

for frm = find([Frm(1,:).used])
    for fac = Frm(frm).factors
        if all(Fac(fac).frames ~= frm)
            fprintf('Frm %d has Fac %d but not viceversa\n', frm, fac)
        end
    end
end

for lmk = find([Lmk.used])
    for fac = Lmk(lmk).factors
        if all(Fac(fac).lmk ~= lmk)
            fprintf('Lmk %d has Fac %d but not viceversa\n', lmk, fac)
        end
    end
end

        
        
