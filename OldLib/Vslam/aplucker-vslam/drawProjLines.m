function obsTab = drawProjLines(obsTab,vis,imSize)


coordNames = {'xdata','ydata'};

for i = 1:size(vis,2)

    if vis(i)

        hm = obsTab(1,i).hm;

        if ~isempty(hm)

            e = trimLine(hm,imSize);
            coordNames = {'xdata','ydata'};

            if ~isempty(e)
                coordValues = {e([1 3]),e([2 4])};
            else
                coordValues = {[],[]};
            end

            set(obsTab(1,i).dispImg.mean,coordNames,coordValues);

        end

    else
        set(obsTab(1,i).dispImg.mean,coordNames,{[],[]});

    end
end
