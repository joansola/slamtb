function sure = sudoku(n)
%
% SUDOKU  Solve Sudoku game.
%   SUDOKU  Solves an empty Sudoku game.
%   SUDOKU(N) solves the N-th stored Sudoku game. 
%
%   The Sudoku game: In a box of 9x9 cells divided in nine
%   squares of 3x3 cells, scalars from 1 to 9 have to be 
%   assigned to each cell, without repeating any number in the 
%   same rows of the box, in the same columns of the box, 
%   or in the same squares.
%
%   Here is an example of a solved Sudoku game:
%
%             \ S U D O K U /        
%     ===============================
%       2  5  6 | 3  1  4 | 8  9  7
%               |         |        
%       4  9  7 | 5  6  8 | 3  2  1
%               |         |        
%       1  3  8 | 7  9  2 | 4  5  6
%       --------|---------|--------
%       5  6  1 | 8  2  3 | 9  7  4
%               |         |        
%       8  4  9 | 6  7  1 | 5  3  2
%               |         |        
%       3  7  2 | 9  4  5 | 1  6  8
%       --------|---------|--------
%       9  2  4 | 1  3  7 | 6  8  5
%               |         |        
%       6  1  5 | 2  8  9 | 7  4  3
%               |         |        
%       7  8  3 | 4  5  6 | 2  1  9
%     ===============================


%   Copyright 2005 Joan Sola

if nargin == 0
    sure = zeros(9,9);

else
    if n>4
        n=ceil(4*rand);
    end
    
    game(:,:,1) = ...
       [0 0 0 0 0 0 0 0 1
        0 0 2 0 0 8 0 9 0
        0 0 0 4 7 0 0 6 0
        0 0 0 3 0 0 6 0 0
        0 7 0 0 0 0 2 5 0
        0 8 6 0 0 9 0 0 0
        0 3 0 0 8 5 0 0 0
        0 4 0 0 0 0 5 7 0
        9 0 0 1 0 0 0 0 0];
    game(:,:,2) = ...
       [2 5 0 0 0 0 0 0 0
        0 0 7 0 0 0 3 2 1
        0 0 8 0 9 0 0 0 6
        0 0 0 8 0 0 0 7 0
        0 4 0 6 0 1 0 3 0
        0 7 0 0 0 5 0 0 0
        9 0 0 0 3 0 6 0 0
        6 1 5 0 0 0 7 0 0
        0 0 0 0 0 0 0 1 9];
    game(:,:,3) = ...
       [6 3 0 4 0 0 0 0 0
        0 1 0 0 3 0 6 7 0
        0 0 2 7 6 0 0 3 0
        3 8 0 0 0 0 0 0 0
        0 0 9 0 0 0 2 0 0
        0 0 0 0 0 0 0 8 7
        0 2 0 0 7 3 5 0 0
        0 9 5 0 1 0 0 4 0
        0 0 0 0 0 9 0 6 0];
    game(:,:,4) = ...
       [0 4 0 0 9 3 0 0 0
        0 2 0 0 0 0 9 0 0
        9 0 3 2 7 0 4 6 0
        0 9 6 0 0 0 0 1 0
        0 0 1 0 0 0 8 0 0
        0 5 0 0 2 0 3 9 0
        0 6 8 0 4 1 7 0 3
        0 0 9 0 0 0 0 8 0
        0 0 0 7 3 0 0 5 0];

    sure = game(:,:,n);
    clear game
end

% Initialize cell options
opt = initOpt(sure);

% Start solving
gameover = false;
while ~gameover
    % user input
    tic
    dispSudoku(sure,.5);
    str = input('<Fila Col Numero> / <RET> continua / <0> acaba : ','s');
    tic
    if length(str) == 3 && str2double(str) >=1 && str2double(str) <= 999
        r = str2double(str(1));
        c = str2double(str(2));
        n = str2double(str(3));
        sure(r,c) = n;
        if n == 0
            opt = initOpt(sure);
        else
            opt{r,c}  = n;
        end
    end

    if str=='0'
        break
    end

    chcont = 2;
    while chcont
        
        % Check for isolated options
        opt = chckIsoOpt(opt);
        
        % Check for cell options
        [opt,sure,change] = chckCellOpt(opt,sure);
        
        % change counter
        if change
            chcont = 2;
        else
            chcont = chcont - 1;
        end
        
        % Check for end of game
        if all(all(sure)) && ~change
            gameover = true;
        end
    end

end

fprintf('            Game over!\n\n')
