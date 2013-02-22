function Sen = prepareForActiveInit(Sen,Obs)

if strcmp(Obs.ltype(4:6),'Pnt')
    if Obs.vis
        c = getCell(Obs.exp.e,Sen.imGrid);
        Sen.imGrid.usedCell(c(2),c(1)) = true;
    end
end









