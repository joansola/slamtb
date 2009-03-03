function opt = chckCol(opt,sure,c)

% CHCKCOL Check existence in column
%   OPT = CHCKCOL(OPT,SURE,C) checks in all cells in column C and
%   eliminates options that exist already in the column.

%   Copyright 2005 Joan Sola

for r=1:9
    opt(opt==sure(r,c)) = [];
end