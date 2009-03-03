%INITVIDEO  Initialize video objects for experiment

if video
    
    videoPosMap  = [1 1051 560 420];
    videoPosImg  = [651 1051 560 420];

    set(mapFig,'pos',videoPosMap);
    set(imgFig,'pos',videoPosImg);
    set(imgAxes,'pos',[0 0 1 1])

    seqFileImg     = [figdir experim '-img-%04d.png'];

    
    if video == 1
        
        seqFileMap  = [figdir experim '-map-%04d.png'];
        imgFrame(mapFig,sprintf(seqFileMap,fmin-1));   
        
    else % second viewpoint for map
        
        seqFileMapTop  = [figdir experim '-map-top-%04d.png'];
        seqFileMapSide = [figdir experim '-map-side-%04d.png'];
        imgFrame(mapFig,sprintf(seqFileMapTop,fmin-1));
        camorbit(mapAxes,0,-90)
        imgFrame(mapFig,sprintf(seqFileMapSide,fmin-1));
        camorbit(mapAxes,0,90)
    end

    imgFrame(imgFig,sprintf(seqFileImg,fmin-1),imgAxes);

end
