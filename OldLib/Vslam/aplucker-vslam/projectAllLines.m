function obsTab = projectAllLines(obsTab,Cam,Lmk,innSpace)

for c = 1:numel(Cam)
    for i = find([Lmk.Line.used])
    
        obsTab(c,i) = projectLine(obsTab(c,i),Cam(c),Lmk.Line(i),innSpace);
        
    end
end
