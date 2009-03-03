function [opt,sure,change] = chckCellOpt(opt,sure)

% CHCKCELLOPT Check cell options

% Discard cell options on self row, self column
%   or self square existence
change = false;
for r = 1:9
    for c = 1:9

        if sure(r,c) == 0
            opt{r,c} = chckCol(opt{r,c},sure,c);
            opt{r,c} = chckRow(opt{r,c},sure,r);
            opt{r,c} = chckSqr(opt{r,c},sure,r,c);

            if length(opt{r,c}) == 1
                sure(r,c) = opt{r,c};
                change = true;
                dispSudoku(sure,.5);
%                 pause
            end

        end

    end

end
