% INITPATCHESFIG


if plotPatches

    fig3 = figure(3);
    set(fig3,...
        'pos',[1 1 435 294],...
        'toolbar','none');
    clf
    rows = 6;
    cols = 12;
    ax3(rows*cols)       = 0;
    dispPatch(rows*cols) = 0;

    for j=1:rows
        for i=1:cols
            k = i+cols*(j-1);
            ax3(k) = subplot(rows,cols,k);
            set(ax3(k),...
                'ydir','reverse',...
                'xlim',[.5 patchSize+.5],...
                'ylim',[.5 patchSize+.5],...
                'fontsize',8,...
                'xticklabel',[],...
                'yticklabel',[])
            tit = get(ax3(k),'title');
            set(tit,'string','--','fontsize',8);
            axis square
            dispPatch(k) = image(...
                'parent',ax3(k),...
                'cdata',[]);
            colormap(gray(256));
        end
    end

end